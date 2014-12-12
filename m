Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868AbaLLI15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:27:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38563 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbaLLI1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:27:50 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f3-548aa6f563b1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: kgene.kim@samsung.com, rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv3 2/7] devfreq: event: Add the list of supported
 devfreq-event type
Date: Fri, 12 Dec 2014 17:27:27 +0900
Message-id: <1418372852-12454-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkQPfbsq4Qg0fvmC0er1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZVzc
	85Sl4LNRxZvZW9gbGLdodTFyckgImEh83vGHBcIWk7hwbz1bFyMXh5DAUkaJbdtWscMU/enY
	xwyRWMQocWH7JEYIp4lJ4tys/cwgVWwCWhL7X9xgA7FFBMwldi39CTaKWeASk8T2mT1MIAlh
	gUiJn3+7wMayCKhKrFr/CayZV8BVYsOUjawQ6xQkli2fCWZzCrhJvLi6AWgbB9A2V4mfS+pA
	ZkoInGKXeL/hDBvEHAGJb5MPsYDUSAjISmw6wAwxRlLi4IobLBMYhRcwMqxiFE0tSC4oTkov
	MtErTswtLs1L10vOz93ECIyV0/+eTdjBeO+A9SFGAQ5GJR7eF6ldIUKsiWXFlbmHGE2BNkxk
	lhJNzgdGZF5JvKGxmZGFqYmpsZG5pZmSOO9rqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhiTooQqVV2Vrm2Oeh5o6vLcf8bn8KnRezfMc+KzDfrSuHr/q9uLqifFukeuvFZ0e330xyf/
	G4/rz9rF/Ne3VPbyPtEg1j6L1ayf2p67NOUqNsdNP8o51/9Hi2fshPlzuD47WJ+WmXtrxpHF
	iw6daxP5IsZ6xYkrx+epqHCM0yP75qqop61FC2YqsRRnJBpqMRcVJwIAgEugOJACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAd2vy7pCDN6tNbd4vGYxk8XGGetZ
	La5/ec5qMf/IOVaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWtxtXsFk8
	XvGW3WLVrj+MDnweO2fdZfdYvOclk8fmJfUefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SokkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjHj4p6nLAWfjSrezN7C3sC4RauLkZNDQsBE4k/HPmYIW0zi
	wr31bF2MXBxCAosYJS5sn8QI4TQxSZybtR+sik1AS2L/ixtsILaIgLnErqU/wTqYBS4xSWyf
	2cMEkhAWiJT4+beLHcRmEVCVWLX+E1gzr4CrxIYpG1kh1ilILFs+E8zmFHCTeHF1A9A2DqBt
	rhI/l9RNYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Ep9J7WBc2WBxiFGAg1GJ
	h/dFaleIEGtiWXFl7iFGCQ5mJRHev1FAId6UxMqq1KL8+KLSnNTiQ4ymQEdNZJYSTc4HJom8
	knhDYxMzI0sjc0MLI2NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+Jg5OqQbGE6vW2k0ucc/+pM76
	63fsgWcFOldOyk5MVkj9PifEXnUZo3rlycL14tN6RLZeY4sQmCR//vy/R+k3LB6sPLBbZfaW
	4lWM63Sa86tbNVOnbeM/JOkg+FRd4LPVMuvEL28Vnl98/uHCSu0v8qrltXmLuv6GZa4udNcX
	DPiaK/Xwjf4rjV81AkKaSizFGYmGWsxFxYkA7ho8KNoCAAA=
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
 drivers/devfreq/devfreq-event.c | 44 +++++++++++++++++++++++++++++++++++++----
 include/linux/devfreq.h         | 29 ++++++++++++++++++++++-----
 2 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
index eaf59c1..9444f93 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -29,6 +29,9 @@
 #include <linux/of.h>
 #include "governor.h"
 
+#define EVENT_TYPE_RAW_DATA_MAX		U64_MAX
+#define EVENT_TYPE_UTILIZATION_MAX	100
+
 static struct class *devfreq_event_class;
 
 /* The list of all devfreq event list */
@@ -144,7 +147,8 @@ EXPORT_SYMBOL_GPL(devfreq_event_is_enabled);
  * Note that this function set the event to the devfreq-event device to start
  * for getting the event data which could be various event type.
  */
-int devfreq_event_set_event(struct devfreq_event_dev *edev)
+int devfreq_event_set_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type)
 {
 	int ret;
 
@@ -158,7 +162,15 @@ int devfreq_event_set_event(struct devfreq_event_dev *edev)
 		return -EPERM;
 
 	mutex_lock(&edev->lock);
-	ret = edev->desc->ops->set_event(edev);
+
+	if ((edev->desc->type & type) == 0) {
+		dev_err(&edev->dev, "unsupported of devfreq-event type\n");
+		mutex_unlock(&edev->lock);
+		return -EINVAL;
+	}
+
+	ret = edev->desc->ops->set_event(edev, type);
+
 	mutex_unlock(&edev->lock);
 
 	return ret;
@@ -174,7 +186,9 @@ EXPORT_SYMBOL_GPL(devfreq_event_set_event);
  * current event data and total_event should be stored in second parameter
  * (total_event).
  */
-u64 devfreq_event_get_event(struct devfreq_event_dev *edev, u64 *total_event)
+u64 devfreq_event_get_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type,
+				u64 *total_event)
 {
 	u64 event;
 
@@ -190,7 +204,27 @@ u64 devfreq_event_get_event(struct devfreq_event_dev *edev, u64 *total_event)
 		return 0;
 
 	mutex_lock(&edev->lock);
-	event = edev->desc->ops->get_event(edev, total_event);
+
+	if ((edev->desc->type & type) == 0) {
+		dev_err(&edev->dev, "unsupported of devfreq-event type\n");
+		return -EINVAL;
+	}
+
+	event = edev->desc->ops->get_event(edev, type, total_event);
+
+	switch (type) {
+	case DEVFREQ_EVENT_TYPE_RAW_DATA:
+	case DEVFREQ_EVENT_TYPE_BANDWIDTH:
+	case DEVFREQ_EVENT_TYPE_LATENCY:
+		if ((event > *total_event)
+			|| ((event > EVENT_TYPE_RAW_DATA_MAX) ||
+				*total_event > EVENT_TYPE_RAW_DATA_MAX))
+			event = 0;
+	case DEVFREQ_EVENT_TYPE_UTILIZATION:
+		if (event > EVENT_TYPE_UTILIZATION_MAX)
+			event = 0;
+	}
+
 	mutex_unlock(&edev->lock);
 
 	return event;
@@ -215,8 +249,10 @@ int devfreq_event_reset_event(struct devfreq_event_dev *edev)
 		return -EPERM;
 
 	mutex_lock(&edev->lock);
+
 	if (edev->desc->ops && edev->desc->ops->reset)
 		ret = edev->desc->ops->reset(edev);
+
 	mutex_unlock(&edev->lock);
 
 	if (ret < 0)
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index a8d2277..82da235 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -197,6 +197,14 @@ struct devfreq_event_dev {
 	const struct devfreq_event_desc *desc;
 };
 
+/* The supported type by devfreq-event device */
+enum devfreq_event_type {
+	DEVFREQ_EVENT_TYPE_RAW_DATA	= BIT(0),
+	DEVFREQ_EVENT_TYPE_UTILIZATION	= BIT(1),
+	DEVFREQ_EVENT_TYPE_BANDWIDTH	= BIT(2),
+	DEVFREQ_EVENT_TYPE_LATENCY	= BIT(3),
+};
+
 /**
  * struct devfreq_event_ops - the operations of devfreq-event device
  *
@@ -219,8 +227,10 @@ struct devfreq_event_ops {
 	int (*reset)(struct devfreq_event_dev *event_dev);
 
 	/* Mandatory functions */
-	int (*set_event)(struct devfreq_event_dev *event_dev);
-	u64 (*get_event)(struct devfreq_event_dev *event_dev, u64 *total_event);
+	int (*set_event)(struct devfreq_event_dev *event_dev,
+			enum devfreq_event_type type);
+	u64 (*get_event)(struct devfreq_event_dev *event_dev,
+			enum devfreq_event_type type, u64 *total_event);
 };
 
 /**
@@ -228,6 +238,10 @@ struct devfreq_event_ops {
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
@@ -236,6 +250,7 @@ struct devfreq_event_ops {
 struct devfreq_event_desc {
 	const char *name;
 	void *driver_data;
+	enum devfreq_event_type type;
 
 	struct devfreq_event_ops *ops;
 };
@@ -273,8 +288,10 @@ extern void devm_devfreq_unregister_opp_notifier(struct device *dev,
 extern int devfreq_event_enable_edev(struct devfreq_event_dev *edev);
 extern int devfreq_event_disable_edev(struct devfreq_event_dev *edev);
 extern bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
-extern int devfreq_event_set_event(struct devfreq_event_dev *edev);
+extern int devfreq_event_set_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type);
 extern u64 devfreq_event_get_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type,
 				u64 *total_event);
 extern int devfreq_event_reset_event(struct devfreq_event_dev *edev);
 extern void *devfreq_event_get_drvdata(struct devfreq_event_dev *edev);
@@ -397,13 +414,15 @@ static inline bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
 	return false;
 }
 
-static inline int devfreq_event_set_event(struct devfreq_event_dev *edev);
+static inline int devfreq_event_set_event(struct devfreq_event_dev *edev,
+					enum devfreq_event_type type)
 {
 	return -EINVAL;
 }
 
 static inline u64 devfreq_event_get_event(struct devfreq_event_dev *edev
-					u64 *total_event);
+					enum devfreq_event_type type,
+					u64 *total_event)
 {
 	return 0;
 }
-- 
1.8.5.5

