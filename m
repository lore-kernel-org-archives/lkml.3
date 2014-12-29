Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaL2AEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:04:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36389 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaL2AE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:04:26 -0500
X-AuditID: cbfee68e-f79b46d000002b74-93-54a09a864cd8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv6 2/9] devfreq: event: Add the list of supported devfreq-event
 type
Date: Mon, 29 Dec 2014 09:04:06 +0900
Message-id: <1419811453-16160-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
References: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSots+a0GIwfzTbBaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1cA9a94y26xatcfRgd+jzXz1jB67Jx1l91j8Z6XTB6bl9R79G1ZxejxeZNcAFsUl01Kak5m
	WWqRvl0CV8bc4/eYCg6aVKzd+421gfG0dhcjJ4eEgInE/vWX2SFsMYkL99azdTFycQgJLGWU
	+LzkLTNMUfehQ6wQiemMEl/fvmaHcJqYJBrPv2cEqWIT0JLY/+IGG4gtIiAjcXXjdhaQImaB
	RmaJL8v+M3UxcnAIC4RKPLnmClLDIqAqsfPZYbAwr4CrxJduP4hlChLLls9kBbE5Bdwk9py4
	AXaEEFDJ+f8HwY6QELjHLrH02Hd2iDkCEt8mH2IBmSMhICux6QDU0ZISB1fcYJnAKLyAkWEV
	o2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmD0nP73rG8H480D1ocYBTgYlXh4JxybHyLEmlhW
	XJl7iNEUaMNEZinR5HxgjOaVxBsamxlZmJqYGhuZW5opifMmSP0MFhJITyxJzU5NLUgtii8q
	zUktPsTIxMEp1cCoHfHhRzVf04TZ+ovOc/1v/ZRre2FteO+3yvS96zcvdbz5bI3NgU9bp2fI
	t6tN7RfmdJpbL8HrMnnOnwm6zNP27Ps960HE6odzymX1763bP38X137m1Fafpy6y2y/7m8h6
	Hlx5sU35alb/Jvb41V3PrKUXtWUs+M5eN/dzU/965TcL1/6e6+X6UImlOCPRUIu5qDgRAN4J
	XiqZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQd22WQtCDN5+tLR4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzJh7/B5TwUGTirV7v7E2MJ7W7mLk5JAQ
	MJHoPnSIFcIWk7hwbz1bFyMXh5DAdEaJr29fs0M4TUwSjeffM4JUsQloSex/cYMNxBYRkJG4
	unE7C0gRs0Ajs8SXZf+Zuhg5OIQFQiWeXHMFqWERUJXY+ewwWJhXwFXiS7cfxDIFiWXLZ4It
	5hRwk9hz4gYziC0EVHL+/0HWCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx+Yz
	6R2MqxosDjEKcDAq8fBOODY/RIg1say4MvcQowQHs5IIr1HZghAh3pTEyqrUovz4otKc1OJD
	jKZAR01klhJNzgemjbySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQimD4mDk6p
	BsbuBCeG264msz5Ln3jcK3Fa6vLRRdvfHeyI37cuftW8N5tbXH6HeU78++AE+3GDmRf/HJuq
	tnvv+kRlmyXLZ23lEQ06PP3Uj/IYVt2HxgGbVu23e919UO8ry+JLK251BEZsrnHeyrxBmH/2
	Xh335YVbM1769S/dGbO7OzJHQN750CZDnvvSLoKLlFiKMxINtZiLihMBkgp9aOMCAAA=
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
 include/linux/devfreq-event.h   | 25 +++++++++++++++---
 2 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
index 81448ba..64c1764 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -20,6 +20,9 @@
 #include <linux/list.h>
 #include <linux/of.h>
 
+#define EVENT_TYPE_RAW_DATA_MAX		ULONG_MAX
+#define EVENT_TYPE_UTILIZATION_MAX	100
+
 static struct class *devfreq_event_class;
 
 /* The list of all devfreq event list */
@@ -132,7 +135,8 @@ EXPORT_SYMBOL_GPL(devfreq_event_is_enabled);
  * Note that this function set the event to the devfreq-event device to start
  * for getting the event data which could be various event type.
  */
-int devfreq_event_set_event(struct devfreq_event_dev *edev)
+int devfreq_event_set_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type)
 {
 	int ret;
 
@@ -146,7 +150,15 @@ int devfreq_event_set_event(struct devfreq_event_dev *edev)
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
@@ -162,6 +174,7 @@ EXPORT_SYMBOL_GPL(devfreq_event_set_event);
  * after stoping the progress of whole sequence of devfreq-event dev.
  */
 int devfreq_event_get_event(struct devfreq_event_dev *edev,
+			    enum devfreq_event_type type,
 			    struct devfreq_event_data *edata)
 {
 	int ret;
@@ -175,18 +188,49 @@ int devfreq_event_get_event(struct devfreq_event_dev *edev,
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
diff --git a/include/linux/devfreq-event.h b/include/linux/devfreq-event.h
index 6023be8..6b86c1d 100644
--- a/include/linux/devfreq-event.h
+++ b/include/linux/devfreq-event.h
@@ -36,6 +36,14 @@ struct devfreq_event_dev {
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
@@ -69,8 +77,10 @@ struct devfreq_event_ops {
 	int (*reset)(struct devfreq_event_dev *edev);
 
 	/* Mandatory functions */
-	int (*set_event)(struct devfreq_event_dev *edev);
+	int (*set_event)(struct devfreq_event_dev *edev,
+			 enum devfreq_event_type type);
 	int (*get_event)(struct devfreq_event_dev *edev,
+			 enum devfreq_event_type type,
 			 struct devfreq_event_data *edata);
 };
 
@@ -79,6 +89,10 @@ struct devfreq_event_ops {
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
@@ -87,6 +101,7 @@ struct devfreq_event_ops {
 struct devfreq_event_desc {
 	const char *name;
 	void *driver_data;
+	enum devfreq_event_type type;
 
 	struct devfreq_event_ops *ops;
 };
@@ -95,8 +110,10 @@ struct devfreq_event_desc {
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
@@ -123,12 +140,14 @@ static inline bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
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

