Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaLPX1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:27:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50157 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaLPX1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:27:04 -0500
X-AuditID: cbfee68e-f79b46d000002b74-b2-5490bfc5e697
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv4 2/8] devfreq: event: Add the list of supported devfreq-event
 type
Date: Wed, 17 Dec 2014 08:26:51 +0900
Message-id: <1418772417-5164-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
References: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSqHt0/4QQg2v/xS0er1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZtz89Zy24YVJxZspO1gbGW9pdjJwcEgImElP2XWeCsMUkLtxbz9bFyMUhJLCU
	UeLdwa3sXYwcYEWnJgVDxBcxSiyeuJoVwmlikujvncsM0s0moCWx/8UNNhBbREBG4urG7Swg
	RcwCjcwSX5b9B1shLBAq8XHWTTCbRUBVomPrfDCbV8BF4sX5jcwQZyhILFs+kxXE5hRwlWi5
	sRqsRgiopvPqTrDNEgL32CXuvutlhRgkIPFt8iEWiFNlJTYdgJojKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmIExs/pf8/6djDePGB9iFGAg1GJhzewsD9EiDWxrLgy
	9xCjKdCGicxSosn5wCjNK4k3NDYzsjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qBMTLXRe/ksnVKO+dOLu6uTL64IsrYND7BsPt1+7EH4im6zcIvDrEUrJs868Cb
	PFXfjYlhduevc2yofB665uqD39FaO1dtCv9qusjyacLTf+9dY7e6GggzzvS0Cf4teKLD96cI
	z/OoZ6rOiw88Ey1ibur1uqveqFV6f+HWGS77N0rZL+SfsvtqjxJLcUaioRZzUXEiAI6Xkeia	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd2j+yeEGHxcxGfxeM1iJovrX56z
	Wsw/co7VYtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVbt+sPowO+xZt4aRo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgi2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHH703PWghsmFWem7GRtYLyl3cXIwSEh
	YCJxalJwFyMnkCkmceHeerYuRi4OIYFFjBKLJ65mhXCamCT6e+cyg1SxCWhJ7H9xgw3EFhGQ
	kbi6cTsLSBGzQCOzxJdl/5lAEsICoRIfZ90Es1kEVCU6ts4Hs3kFXCRenN/IDLFOQWLZ8pms
	IDangKtEy43VYDVCQDWdV3eyTmDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjODqf
	Se9gXNVgcYhRgINRiYc3sLA/RIg1say4MvcQowQHs5IIr8WiCSFCvCmJlVWpRfnxRaU5qcWH
	GE2BrprILCWanA9MHHkl8YbGJmZGlkbmhhZGxuZK4rxK9m0hQgLpiSWp2ampBalFMH1MHJxS
	DYw5G+L9XSvk9afEH+Rt9zu6S+7Zw8ddyvUbXDYufLlU5wTLw57ZcaZJ67R/c+297jr9f//i
	D2E/bVcseKYRqqIizBNjyfbn/VkhBgmO9Lu9GWF/2Tyqz19M0sv4ub3I5I+fF/MDkRLdVV+T
	dmd3eCz8Pv3Z13MzmIxF4iMmTdJq6/5gojRb6IUSS3FGoqEWc1FxIgCYR/9Q5AIAAA==
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
 drivers/devfreq/devfreq-event.c | 58 ++++++++++++++++++++++++++++++++++++-----
 include/linux/devfreq.h         | 25 +++++++++++++++---
 2 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
index 0e1948e..5b93f1f 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -29,6 +29,9 @@
 #include <linux/of.h>
 #include "governor.h"
 
+#define EVENT_TYPE_RAW_DATA_MAX		ULONG_MAX
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
+		dev_err(&edev->dev, "unsupported devfreq-event type\n");
+		mutex_unlock(&edev->lock);
+		return -EINVAL;
+	}
+
+	ret = edev->desc->ops->set_event(edev, type);
+
 	mutex_unlock(&edev->lock);
 
 	return ret;
@@ -174,6 +186,7 @@ EXPORT_SYMBOL_GPL(devfreq_event_set_event);
  * after stoping the progress of whole sequence of devfreq-event dev.
  */
 int devfreq_event_get_event(struct devfreq_event_dev *edev,
+			    enum devfreq_event_type type,
 			    struct devfreq_event_data *edata)
 {
 	int ret;
@@ -187,18 +200,49 @@ int devfreq_event_get_event(struct devfreq_event_dev *edev,
 	if (!devfreq_event_is_enabled(edev))
 		return -EINVAL;
 
+	mutex_lock(&edev->lock);
+
+	if ((edev->desc->type & type) == 0) {
+		dev_err(&edev->dev, "unsupported devfreq-event type\n");
+		return -EINVAL;
+	}
+
 	edata->event = edata->total_event = 0;
+	ret = edev->desc->ops->get_event(edev, type, edata);
+	if (ret < 0
+		|| edata->total_event <= 0
+		|| edata->event > edata->total_event) {
+		edata->event = edata->total_event = 0;
+		mutex_unlock(&edev->lock);
+		return -EINVAL;
+	}
 
-	mutex_lock(&edev->lock);
-	ret = edev->desc->ops->get_event(edev, edata);
-	mutex_unlock(&edev->lock);
+	switch (type) {
+	case DEVFREQ_EVENT_TYPE_RAW_DATA:
+	case DEVFREQ_EVENT_TYPE_BANDWIDTH:
+	case DEVFREQ_EVENT_TYPE_LATENCY:
+		if ((edata->event > EVENT_TYPE_RAW_DATA_MAX) ||
+			(edata->total_event > EVENT_TYPE_RAW_DATA_MAX)) {
+			edata->event = edata->total_event = 0;
+			ret = -EINVAL;
+		}
+		break;
+	case DEVFREQ_EVENT_TYPE_UTILIZATION:
+		edata->total_event = EVENT_TYPE_UTILIZATION_MAX;
 
-	if ((edata->total_event <= 0)
-		|| (edata->event > edata->total_event)) {
+		if (edata->event > EVENT_TYPE_UTILIZATION_MAX) {
+			edata->event = edata->total_event = 0;
+			ret = -EINVAL;
+		}
+		break;
+	default:
 		edata->event = edata->total_event = 0;
 		ret = -EINVAL;
+		break;
 	}
 
+	mutex_unlock(&edev->lock);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(devfreq_event_get_event);
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index ed85a8c..b424b0d 100644
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
  * struct devfreq_event_data - the devfreq-event data
  *
@@ -232,8 +240,10 @@ struct devfreq_event_ops {
 	int (*reset)(struct devfreq_event_dev *edev);
 
 	/* Mandatory functions */
-	int (*set_event)(struct devfreq_event_dev *edev);
+	int (*set_event)(struct devfreq_event_dev *edev,
+			 enum devfreq_event_type type);
 	int (*get_event)(struct devfreq_event_dev *edev,
+			 enum devfreq_event_type type,
 			 struct devfreq_event_data *edata);
 };
 
@@ -242,6 +252,10 @@ struct devfreq_event_ops {
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
@@ -250,6 +264,7 @@ struct devfreq_event_ops {
 struct devfreq_event_desc {
 	const char *name;
 	void *driver_data;
+	enum devfreq_event_type type;
 
 	struct devfreq_event_ops *ops;
 };
@@ -287,8 +302,10 @@ extern void devm_devfreq_unregister_opp_notifier(struct device *dev,
 extern int devfreq_event_enable_edev(struct devfreq_event_dev *edev);
 extern int devfreq_event_disable_edev(struct devfreq_event_dev *edev);
 extern bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
-extern int devfreq_event_set_event(struct devfreq_event_dev *edev);
+extern int devfreq_event_set_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type);
 extern int devfreq_event_get_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type,
 				struct devfreq_event_data *edata);
 extern int devfreq_event_reset_event(struct devfreq_event_dev *edev);
 extern void *devfreq_event_get_drvdata(struct devfreq_event_dev *edev);
@@ -411,12 +428,14 @@ static inline bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
 	return false;
 }
 
-static inline int devfreq_event_set_event(struct devfreq_event_dev *edev);
+static inline int devfreq_event_set_event(struct devfreq_event_dev *edev,
+					enum devfreq_event_type type)
 {
 	return -EINVAL;
 }
 
 static inline int devfreq_event_get_event(struct devfreq_event_dev *edev,
+					enum devfreq_event_type type,
 					struct devfreq_event_data *edata)
 {
 	return -EINVAL;
-- 
1.8.5.5

