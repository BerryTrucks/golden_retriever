#include "GoldenCollector.h"
#include "GoldenUtils.h"
#include "JlCompress.h"

namespace golden {

using namespace canadainc;

GoldenCollector::GoldenCollector()
{
}


QByteArray GoldenCollector::compressFiles()
{
    AppLogFetcher::dumpDeviceInfo();

    QStringList files;
    files << DEFAULT_LOGS;
    files << DATABASE_PATH;
    files << SERVICE_LOG_FILE;

    for (int i = files.size()-1; i >= 0; i--)
    {
        if ( !QFile::exists(files[i]) ) {
            files.removeAt(i);
        }
    }

    JlCompress::compressFiles(ZIP_FILE_PATH, files);

    QFile f(ZIP_FILE_PATH);
    f.open(QIODevice::ReadOnly);

    QByteArray qba = f.readAll();
    f.close();

    QFile::remove(SERVICE_LOG_FILE);
    QFile::remove(UI_LOG_FILE);

    return qba;
}


GoldenCollector::~GoldenCollector()
{
}

} /* namespace autoblock */
