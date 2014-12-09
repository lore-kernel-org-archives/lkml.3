Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbaLIONQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:13:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:49933 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaLIONK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:10 -0500
X-AuditID: cbfee68f-f791c6d000004834-94-54870374eceb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 2/7] devfreq: event: Add the list of supported
 devfreq-event type
Date: Tue, 09 Dec 2014 23:13:01 +0900
Message-id: <1418134386-14681-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkQLeEuT3EYMcbbovHaxYzWWycsZ7V
	4vqX56wW84+cY7V4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Rxu3EFm8Xj
	FW/ZLVbt+sPowOexc9Zddo/Fe14yeWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGQc2
	r2YseKZbMf3vcqYGxidqXYycHBICJhJHLp5lhbDFJC7cW8/WxcjFISSwlFGiZcF2Zpiiz803
	GSESixglDs55ywThNDFJrJ/fyg5SxSagJbH/xQ02EFtEwEri9P8OZpAiZoHzTBJLFu4HGyUs
	ECmxo+MdmM0ioCoxadpVsN28Aq4Si/e8Y4FYpyCxbPlMsDingJtE0+5GsLgQUM2HEyDLuIBq
	TrFLTN82nQVikIDEt8mHgGwOoISsxKYDUGdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJ
	ucWleel6yfm5mxiB0XL637P+HYx3D1gfYhTgYFTi4dWwbAsRYk0sK67MPcRoCrRhIrOUaHI+
	MCbzSuINjc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAODsk
	IfeDq264wlG5A9P2PhWT/WDbbVPe2HGu41VrZPndY/MPd1ukHbN2mviqwTxh0Y04ab8/PQ0d
	fm/mra09L1X58WV4SMvWR6ca057e0Fyt/eVDpUDUQeHXR85kqQRk/C/frXnwScB/3kIP93e/
	n5ZUBi1K6ryumWC10vBp6LbzBzPmlonuV2Ipzkg01GIuKk4EANfGfomRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jAd0S5vYQg4O7mCwer1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEY1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsYcw4sHk1Y8Ez3Yrpf5czNTA+Ueti5OSQEDCR+Nx8kxHCFpO4
	cG89WxcjF4eQwCJGiYNz3jJBOE1MEuvnt7KDVLEJaEnsf3GDDcQWEbCSOP2/gxmkiFngPJPE
	koX7mUESwgKREjs63oHZLAKqEpOmXWUFsXkFXCUW73nHArFOQWLZ8plgcU4BN4mm3Y1gcSGg
	mg8nWtknMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREci8+kdjCubLA4xCjAwajE
	w6tp2RYixJpYVlyZe4hRgoNZSYR3ylGgEG9KYmVValF+fFFpTmrxIUZToKsmMkuJJucD00Re
	SbyhsYmZkaWRuaGFkbG5kjivkj1Qk0B6YklqdmpqQWoRTB8TB6dUA+P2s28t7j2JTeje6MTz
	2PpCzK3r5Uudz6m/3ylwdIJpXF0Tk7xP9XXT3Opzt6L3xbFzlBR8t6ra9C1l4qsXXg79ikcN
	K5zvfprwSexwLd8cSw7F9TK2EcKb/+mHfL1lts/o2OeUZYXCIjw5X8I+71mYOrG5kYutZHV2
	Q1717I0HdjyLXxjWX6XEUpyRaKjFXFScCABUqq7h2wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the list of supported devfreq-event type as following.
Each devfreq-event device driver would support the various devfreq-event type
for devfreq governor at the same time.
- DEVFREQ_EVENT_TYPE_RAW_DATA
- DEVFREQ_EVENT_TYPE_UTILIZATION
- DEVFREQ_EVENT_TYPE_BANDWIDTH
- DEVFREQ_EVENT_TYPE_LATENCY

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/devfreq-event.c | 23 ++++++++++++++++++++---
 include/linux/devfreq.h         | 28 ++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
index b47329f..a71fcee 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -203,7 +203,8 @@ bool devfreq_is_enabled_event_dev(struct devfreq_event_dev *event_dev)
 }
 EXPORT_SYMBOL_GPL(devfreq_is_enabled_event_dev);
 
-int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev)
+int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev,
+				enum devfreq_event_type event_type)
 {
 	if (!event_dev || !event_dev->desc)
 		return -EINVAL;
@@ -211,14 +212,22 @@ int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev)
 	if (!devfreq_is_enabled_event_dev(event_dev))
 		return -EPERM;
 
+	if ((event_dev->desc->event_type & event_type) == 0) {
+		dev_err(&event_dev->dev, "unsupported of devfreq-event type\n");
+		return -EINVAL;
+	}
+
 	if (event_dev->desc->ops && event_dev->desc->ops->set_event)
-		return event_dev->desc->ops->set_event(event_dev);
+		return event_dev->desc->ops->set_event(event_dev, event_type);
+
+	dev_err(&event_dev->dev, "failed to set devfreq-event\n");
 
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(devfreq_set_event_event_dev);
 
 int devfreq_get_event_event_dev(struct devfreq_event_dev *event_dev,
+				enum devfreq_event_type event_type,
 				int *total_event)
 {
 	if (!event_dev || !event_dev->desc)
@@ -227,8 +236,16 @@ int devfreq_get_event_event_dev(struct devfreq_event_dev *event_dev,
 	if (!devfreq_is_enabled_event_dev(event_dev))
 		return -EPERM;
 
+	if ((event_dev->desc->event_type & event_type) == 0) {
+		dev_err(&event_dev->dev, "unsupported of devfreq-event type\n");
+		return -EINVAL;
+	}
+
 	if (event_dev->desc->ops && event_dev->desc->ops->get_event)
-		return event_dev->desc->ops->get_event(event_dev, total_event);
+		return event_dev->desc->ops->get_event(event_dev, event_type,
+							total_event);
+
+	dev_err(&event_dev->dev, "failed to get devfreq-event\n");
 
 	return -EINVAL;
 }
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 3c5f233..f6d44b7 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -197,6 +197,15 @@ struct devfreq_event_dev {
 	const struct devfreq_event_desc *desc;
 };
 
+/* The supported type by devfreq-event device */
+enum devfreq_event_type {
+	DEVFREQ_EVENT_TYPE_NONE		= BIT(0),
+	DEVFREQ_EVENT_TYPE_RAW_DATA	= BIT(1),
+	DEVFREQ_EVENT_TYPE_UTILIZATION	= BIT(2),
+	DEVFREQ_EVENT_TYPE_BANDWIDTH	= BIT(3),
+	DEVFREQ_EVENT_TYPE_LATENCY	= BIT(4),
+};
+
 /**
  * struct devfreq_event_ops - the operations of devfreq-event device
  *
@@ -215,8 +224,10 @@ struct devfreq_event_ops {
 	int (*enable)(struct devfreq_event_dev *event_dev);
 	int (*disable)(struct devfreq_event_dev *event_dev);
 	bool (*is_enabled)(struct devfreq_event_dev *event_dev);
-	int (*set_event)(struct devfreq_event_dev *event_dev);
-	int (*get_event)(struct devfreq_event_dev *event_dev, int *total_event);
+	int (*set_event)(struct devfreq_event_dev *event_dev,
+			enum devfreq_event_type);
+	int (*get_event)(struct devfreq_event_dev *event_dev,
+			enum devfreq_event_type, int *total_event);
 	int (*reset)(struct devfreq_event_dev *event_dev);
 };
 
@@ -225,6 +236,10 @@ struct devfreq_event_ops {
  *
  * @name	: the name of devfreq-event device.
  * @driver_data	: the private data for devfreq-event driver.
+ * @event_type	: the supported devfreq-event type among as following
+ *		  - DEVFREQ_EVENT_TYPE_UTILIZATION
+ *		  - DEVFREQ_EVENT_TYPE_BANDWIDTH
+ *		  - DEVFREQ_EVENT_TYPE_LATENCY
  * @ops		: the operation to control devfreq-event device.
  *
  * Each devfreq-event device is described with a this structure.
@@ -233,6 +248,7 @@ struct devfreq_event_ops {
 struct devfreq_event_desc {
 	const char *name;
 	void *driver_data;
+	enum devfreq_event_type event_type;
 
 	struct devfreq_event_ops *ops;
 };
@@ -277,8 +293,10 @@ extern int devfreq_put_event_dev(struct devfreq_event_dev *event_dev);
 extern int devfreq_enable_event_dev(struct devfreq_event_dev *event_dev);
 extern int devfreq_disable_event_dev(struct devfreq_event_dev *event_dev);
 extern bool devfreq_is_enabled_event_dev(struct devfreq_event_dev *event_dev);
-extern int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev);
+extern int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev,
+					enum devfreq_event_type event_type);
 extern int devfreq_get_event_event_dev(struct devfreq_event_dev *event_dev,
+					enum devfreq_event_type event_type,
 					int *total_event);
 extern int devfreq_reset_event_dev(struct devfreq_event_dev *event_dev);
 
@@ -414,13 +432,15 @@ static inline bool devfreq_is_enabled_event_dev(
 }
 
 static inline int devfreq_set_event_event_dev(
-				struct devfreq_event_dev *event_dev)
+				struct devfreq_event_dev *event_dev,
+				enum devfreq_event_type event_type);
 {
 	return -EINVAL;
 }
 
 static inline int devfreq_get_event_event_dev(
 				struct devfreq_event_dev *event_dev,
+				enum devfreq_event_type event_type,
 				int *total_event);
 {
 	return -EINVAL;
-- 
1.8.5.5

