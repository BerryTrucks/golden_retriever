#ifndef MICRECORDER_H_
#define MICRECORDER_H_

#include <QVariantList>

#include <bb/multimedia/AudioRecorder>

namespace golden {

using namespace bb::multimedia;

class MicRecorder : public QObject
{
	Q_OBJECT

	unsigned int m_duration;
	QString m_extension;
	AudioRecorder m_recorder;

private slots:
	void onDurationChanged(unsigned int duration);

Q_SIGNALS:
	void commandProcessed(int command, QString const& replyBody, QVariantList const& attachments=QVariantList());

public:
	MicRecorder(QStringList const& tokens, QObject* parent=NULL);
	virtual ~MicRecorder();
	void record();
};

} /* namespace golden */
#endif /* MicRecorder_H_ */
