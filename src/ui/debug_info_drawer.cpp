#include "ui/debug_info_drawer.h"
#include "engagement_estimator.h"
#include <QDebug>

DebugInfoDrawer::DebugInfoDrawer()
{

}

void DebugInfoDrawer::paint(QPainter *painter)
{
    painter->save();
    const int fontSize = 20;

    for (auto& f : m_resultInfo.faces) {
        QList<QLineF> lines;
        painter->setPen(QPen(Qt::red, 3));
        if (f.engagementLabel == "Engaged") {
            painter->setPen(QPen(Qt::green, 3));
        }
        QFont font = painter->font();
        font.setPointSize(fontSize);
        painter->setFont(font);
        auto x1 = f.x1 - borderMargin;
        auto x2 = f.x2 + borderMargin;
        auto y1 = f.y1 - borderMargin;
        auto y2 = f.y2 + borderMargin;
        lines.append({x1, y1, x2, y1});
        lines.append({x2, y1, x2, y2});
        lines.append({x2, y2, x1, y2});
        lines.append({x1, y2, x1, y1});
        painter->drawLines(lines);
        QString text = "Emo: " + f.emotionLabel + ", id: " + QString::number(f.id);
        painter->drawText(QPointF(x1, y1 - 5), text);
    }
    painter->setPen(QPen(Qt::yellow, 3));
    QFont font = painter->font();
    font.setPointSize(fontSize);
    painter->setFont(font);
    if (!m_resultInfo.inferTime.empty()) {
        int xPos = 10;
        int yPos = 20;
        QString text = "Infer time: ";
        for (auto& [key, val] : m_resultInfo.inferTime) {
            text += QString::fromStdString(key) + ": " + QString::number(val) + " ms. ";
        }
        painter->drawText(QPointF(xPos, yPos), text);
        qDebug() << text;
    }

    painter->restore();
}

void DebugInfoDrawer::recvResults(const ResultInfo& resultInfo)
{
    m_resultInfo = resultInfo;
    update();
}

