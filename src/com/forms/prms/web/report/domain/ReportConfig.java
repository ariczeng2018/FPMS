
package com.forms.prms.web.report.domain;

/**
 * Copy Right Information : Forms Syntron <br>
 * Project : Forms Platform <br>
 * JDK version used:jdk1.4.2_06 <br>
 * Description : ���ڱ������ļ��Ľ��� <br>
 * Comments Name : ReportConfig <br>
 * author ��ronald zhang <br>
 * date ��2006-11-21 <br>
 * Version : 1.00 <br>
 * Modification history : Modified By Why & What is modified Date 2004-11-22 1.
 * 2006-5-10 chenxiaolong add unauthorized forward
 */

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;

import org.dom4j.Node;
import org.dom4j.io.SAXReader;

public class ReportConfig
        extends Object
{
    private static ReportConfig instance;

    // �����ļ�·��
    private String              fileName       = null;

    Class                       cls            = null;

    private HashMap             reportItemList = new HashMap();

    public static ReportConfig newInstance(String fileName)
    {
        if (instance == null)
        {
            instance = new ReportConfig(fileName);
        }
        return instance;
    }

    public static ReportConfig getInstance()
    {
        return instance;
    }

    private ReportConfig (String fileName)
    {
        this.fileName = fileName;
        if (!fileName.equals(""))
        {
            try
            {
                readXMLFile();
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }

    }

    private void readXMLFile() throws Exception
    {

        File file = new File(this.fileName);
        String curPath = file.getParent();
        if (curPath.charAt(curPath.length() - 1) != '/'
                && curPath.charAt(curPath.length() - 1) != '\\')
            curPath = curPath + "/";

        SAXReader reader = new SAXReader();
        FileInputStream fis = new FileInputStream(this.fileName);
        try
        {
            org.dom4j.Document document = reader.read(fis);

            // ��ȡreport-list�е�����report����
            // ȡ����report�б�
            Node listNode = document.selectSingleNode("//report-list");
            if (listNode != null)
            {
                List reportList = listNode.selectNodes("//report");
                if (reportList != null)
                {
                    Node reportNode = null;
                    Node propNode = null;
                    ReportItem reportItem = null;

                    for (int i = 0; i < reportList.size(); ++i)
                    {
                        reportItem = new ReportItem();
                        reportNode = (Node) reportList.get(i);

                        propNode = reportNode.selectSingleNode("report-id");
                        reportItem.setReportID(propNode.getText());

                        propNode = reportNode.selectSingleNode("report-name");
                        reportItem.setReportName(propNode.getText());

                        propNode = reportNode.selectSingleNode("report-file");
                        reportItem.setReportFile(propNode.getText());

                        propNode = reportNode.selectSingleNode("table-file");
                        reportItem.setTableFile(propNode.getText());

                        propNode = reportNode.selectSingleNode("data-class");
                        reportItem.setDataClass(propNode.getText());

                        reportItemList
                                .put(reportItem.getReportID(), reportItem);
                    }
                }
            }
        }
        finally
        {
            if (fis != null)
                fis.close();
        }
    }

    public ReportItem getReportItem(String reportID)
    {
        Object ai = reportItemList.get(reportID);
        if (ai == null)
            return null;
        else
            return (ReportItem) ai;
    }

    // ����thisReport�е�reportID��ȡ��Ӧ�ı����ļ������������е��ֶ�ȫ������thisReport
    public void readReportTable(ThisReport thisReport) throws Exception
    {
        File file = new File(this.fileName);
        String curPath = file.getParent();
        if (curPath.charAt(curPath.length() - 1) != '/'
                && curPath.charAt(curPath.length() - 1) != '\\')
            curPath = curPath + "/";

        SAXReader reader = new SAXReader();
        FileInputStream fis = new FileInputStream(thisReport.getTableFile());
        try
        {
            org.dom4j.Document document = reader.read(fis);

            // ��ȡ����tb�ڵ�
            List tbList = document.selectNodes("//tb");
            if (tbList != null)
            {
                Node tbNode = null;

                for (int i = 0; i < tbList.size(); ++i)
                {
                    tbNode = (Node) tbList.get(i);
                    // table name
                    String tableName = tbNode.valueOf("@name");
                    String tableTitle = tbNode.valueOf("@title");
                    ThisTable thisTable = new ThisTable(tableName);
                    thisTable.setTableTitle(tableTitle);

                    // ��ȡ����field�ڵ�
                    Node fdNode = null;
                    List fdList = tbNode.selectNodes("fd");
                    for (int j = 0; j < fdList.size(); ++j)
                    {
                        fdNode = (Node) fdList.get(j);
                        // ���ֶ������뵽�ֶ�������
                        thisTable.addField(fdNode.valueOf("@name"));

                    }

                    // ����ǰ����뵽��ǰ������
                    thisReport.addTable(thisTable);

                }
            }
        }
        finally
        {
            if (fis != null)
                fis.close();
        }

    }
}