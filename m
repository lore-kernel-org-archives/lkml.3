Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbaJ3MqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:46:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbaJ3Mn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:27 -0400
X-AuditID: cbfee691-f79b86d000004a5a-ab-54523269793f
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 03/10] power: charger-manager: Remove deprecated function,
 cm_notify_event().
Date: Thu, 30 Oct 2014 21:43:09 +0900
Message-id: <1414672996-28355-4-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkUDfTKCjEYMVDXouDWzUtrn95zmox
	6cl7ZouJKyczW3SefcJscXnXHDaLz71HGC1uN65gs7h76iibxendJQ5cHhP6PzF67Jx1l91j
	8wotj02rOtk8+rasYvRYsfo7u8fnTXIB7FFcNimpOZllqUX6dglcGS8bxQu2J1UsOrWEuYFx
	QmAXIyeHhICJxPk7N5ggbDGJC/fWs3UxcnEICSxllLhzaxczTFHLrpVQiUWMEv0Le9khnDYm
	ifNn9zCCVLEJ6Ej833eTHcQWEVCQ2Nz7jBWkiFngCqPEzcXrwXYIC8RL9H2ayQJiswioSvx5
	sxpsBa+Ah8Tq27+BmjmA1ilIzJlkAxLmFPCU2HQFolwIqOTBri52iIt2sUv8OBQAMUZA4tvk
	QywQrbISmw5AHS0pcXDFDZYJjMILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgRGxOl/
	zybuYLx/wPoQowAHoxIP74WjgSFCrIllxZW5hxhNgTZMZJYSTc4Hxl1eSbyhsZmRhamJqbGR
	uaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mqx+fjjpeeWqJx1v9ldxru3Yt
	L19uYbW+p5il8q70ulWneHR0d3vM2frGUnZOzfR9v+f+l7B1co0uWdnL/qzyqZECz2KGA3bL
	1R9PCQ3KFXpmlsX395fhK817d49PX+ewm8185skur2td+rce6Utt3BRtfCPk/9Onz23kN8ed
	Pnx69++du3mu31JiKc5INNRiLipOBADc2fYPgwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd1Mo6AQg2XzmSwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcx42ShesD2pYtGpJcwNjBMCuxg5OSQETCRadq1kg7DFJC7cWw9kc3EICSxilOhf
	2MsO4bQxSZw/u4cRpIpNQEfi/76b7CC2iICCxObeZ6wgRcwCVxglbi5ezwSSEBaIl+j7NJMF
	xGYRUJX482Y1M4jNK+Ahsfr2b6BmDqB1ChJzJtmAhDkFPCU2XYEoFwIqebCri30CI+8CRoZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMER90x6B+OqBotDjAIcjEo8vBonAkOEWBPLiitz
	DzFKcDArifAe1QkKEeJNSaysSi3Kjy8qzUktPsRoCnTURGYp0eR8YDLIK4k3NDYxM7I0Mje0
	MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAyP9K03+zoPZUdYOClikT2yZ8Lv7KOuX1
	3vrPxwvt3ifYTrRenXEo7dCyc2bSuf/nvHkU/uPKg8aExVNPWqhqJS3O3MjCsMjw29O0HX8D
	Li0+mhCjbcovrhbfq+lY6inywCDg1gzuQmkuhsRwYcP7ds0Ttu9ri1Ku28/BM+No/WrJIzI9
	1mtilViKMxINtZiLihMBv26hYM4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cm_notify_event() is introduced to get event associated with battery status
externally, but no one had been used. Moreover it makes charger manager
driver more complicated. This patch tries to drop the function and all data
related to simplify the driver.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 .../bindings/power_supply/charger-manager.txt      |    1 -
 drivers/power/charger-manager.c                    |  196 +-------------------
 include/linux/power/charger-manager.h              |   19 +-
 3 files changed, 8 insertions(+), 208 deletions(-)

diff --git a/Documentation/devicetree/bindings/power_supply/charger-manager.txt b/Documentation/devicetree/bindings/power_supply/charger-manager.txt
index 2b33750..767aaa5 100644
--- a/Documentation/devicetree/bindings/power_supply/charger-manager.txt
+++ b/Documentation/devicetree/bindings/power_supply/charger-manager.txt
@@ -39,7 +39,6 @@ Example :
 		cm-poll-mode = <1>;
 		cm-poll-interval = <30000>;
 
-		cm-fullbatt-vchkdrop-ms = <30000>;
 		cm-fullbatt-vchkdrop-volt = <150000>;
 		cm-fullbatt-soc = <100>;
 
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 33a1a4d..64fdaaf 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -410,25 +410,18 @@ static int try_charger_restart(struct charger_manager *cm)
 
 /**
  * fullbatt_vchk - Check voltage drop some times after "FULL" event.
- * @work: the work_struct appointing the function
  *
- * If a user has designated "fullbatt_vchkdrop_ms/uV" values with
+ * If a user has designated "fullbatt_vchkdrop_uV" values with
  * charger_desc, Charger Manager checks voltage drop after the battery
  * "FULL" event. It checks whether the voltage has dropped more than
  * fullbatt_vchkdrop_uV by calling this function after fullbatt_vchkrop_ms.
  */
-static void fullbatt_vchk(struct work_struct *work)
+static void fullbatt_vchk(struct charger_manager *cm)
 {
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct charger_manager *cm = container_of(dwork,
-			struct charger_manager, fullbatt_vchk_work);
 	struct charger_desc *desc = cm->desc;
 	int batt_uV, err, diff;
 
-	/* remove the appointment for fullbatt_vchk */
-	cm->fullbatt_vchk_jiffies_at = 0;
-
-	if (!desc->fullbatt_vchkdrop_uV || !desc->fullbatt_vchkdrop_ms)
+	if (!desc->fullbatt_vchkdrop_uV)
 		return;
 
 	err = get_batt_uV(cm, &batt_uV);
@@ -585,7 +578,7 @@ static bool _cm_monitor(struct charger_manager *cm)
 	 */
 	} else if (!cm->emergency_stop && is_ext_pwr_online(cm) &&
 			!cm->charger_enabled) {
-		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
+		fullbatt_vchk(cm);
 
 	/*
 	 * Check whether fully charged state to protect overcharge
@@ -598,7 +591,7 @@ static bool _cm_monitor(struct charger_manager *cm)
 
 		try_charger_enable(cm, false);
 
-		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
+		fullbatt_vchk(cm);
 	} else {
 		cm->emergency_stop = 0;
 		if (is_ext_pwr_online(cm)) {
@@ -700,66 +693,6 @@ static void cm_monitor_poller(struct work_struct *work)
 	schedule_work(&setup_polling);
 }
 
-/**
- * fullbatt_handler - Event handler for CM_EVENT_BATT_FULL
- * @cm: the Charger Manager representing the battery.
- */
-static void fullbatt_handler(struct charger_manager *cm)
-{
-	struct charger_desc *desc = cm->desc;
-
-	if (!desc->fullbatt_vchkdrop_uV || !desc->fullbatt_vchkdrop_ms)
-		goto out;
-
-	if (cm_suspended)
-		device_set_wakeup_capable(cm->dev, true);
-
-	mod_delayed_work(cm_wq, &cm->fullbatt_vchk_work,
-			 msecs_to_jiffies(desc->fullbatt_vchkdrop_ms));
-	cm->fullbatt_vchk_jiffies_at = jiffies + msecs_to_jiffies(
-				       desc->fullbatt_vchkdrop_ms);
-
-	if (cm->fullbatt_vchk_jiffies_at == 0)
-		cm->fullbatt_vchk_jiffies_at = 1;
-
-out:
-	dev_info(cm->dev, "EVENT_HANDLE: Battery Fully Charged\n");
-	power_supply_changed(&cm->charger_psy);
-}
-
-/**
- * battout_handler - Event handler for CM_EVENT_BATT_OUT
- * @cm: the Charger Manager representing the battery.
- */
-static void battout_handler(struct charger_manager *cm)
-{
-	if (cm_suspended)
-		device_set_wakeup_capable(cm->dev, true);
-
-	if (!is_batt_present(cm)) {
-		dev_emerg(cm->dev, "Battery Pulled Out!\n");
-		power_supply_changed(&cm->charger_psy);
-	} else {
-		power_supply_changed(&cm->charger_psy);
-	}
-}
-
-/**
- * misc_event_handler - Handler for other evnets
- * @cm: the Charger Manager representing the battery.
- * @type: the Charger Manager representing the battery.
- */
-static void misc_event_handler(struct charger_manager *cm,
-			enum cm_event_types type)
-{
-	if (cm_suspended)
-		device_set_wakeup_capable(cm->dev, true);
-
-	if (is_polling_required(cm) && cm->desc->polling_interval_ms)
-		schedule_work(&setup_polling);
-	power_supply_changed(&cm->charger_psy);
-}
-
 static int charger_get_property(struct power_supply *psy,
 		enum power_supply_property psp,
 		union power_supply_propval *val)
@@ -948,21 +881,6 @@ static bool cm_setup_timer(void)
 
 	mutex_lock(&cm_list_mtx);
 	list_for_each_entry(cm, &cm_list, entry) {
-		unsigned int fbchk_ms = 0;
-
-		/* fullbatt_vchk is required. setup timer for that */
-		if (cm->fullbatt_vchk_jiffies_at) {
-			fbchk_ms = jiffies_to_msecs(cm->fullbatt_vchk_jiffies_at
-						    - jiffies);
-			if (time_is_before_eq_jiffies(
-				cm->fullbatt_vchk_jiffies_at) ||
-				msecs_to_jiffies(fbchk_ms) < CM_JIFFIES_SMALL) {
-				fullbatt_vchk(&cm->fullbatt_vchk_work.work);
-				fbchk_ms = 0;
-			}
-		}
-		CM_MIN_VALID(wakeup_ms, fbchk_ms);
-
 		/* Skip if polling is not required for this CM */
 		if (!is_polling_required(cm) && !cm->emergency_stop)
 			continue;
@@ -1346,8 +1264,6 @@ static struct charger_desc *of_cm_parse_desc(struct device *dev)
 	of_property_read_u32(np, "cm-poll-interval",
 				&desc->polling_interval_ms);
 
-	of_property_read_u32(np, "cm-fullbatt-vchkdrop-ms",
-					&desc->fullbatt_vchkdrop_ms);
 	of_property_read_u32(np, "cm-fullbatt-vchkdrop-volt",
 					&desc->fullbatt_vchkdrop_uV);
 	of_property_read_u32(np, "cm-fullbatt-voltage", &desc->fullbatt_uV);
@@ -1493,9 +1409,8 @@ static int charger_manager_probe(struct platform_device *pdev)
 	if (desc->fullbatt_uV == 0) {
 		dev_info(&pdev->dev, "Ignoring full-battery voltage threshold as it is not supplied\n");
 	}
-	if (!desc->fullbatt_vchkdrop_ms || !desc->fullbatt_vchkdrop_uV) {
+	if (!desc->fullbatt_vchkdrop_uV) {
 		dev_info(&pdev->dev, "Disabling full-battery voltage drop checking mechanism as it is not supplied\n");
-		desc->fullbatt_vchkdrop_ms = 0;
 		desc->fullbatt_vchkdrop_uV = 0;
 	}
 	if (desc->fullbatt_soc == 0) {
@@ -1609,8 +1524,6 @@ static int charger_manager_probe(struct platform_device *pdev)
 		cm->desc->measure_battery_temp = false;
 	}
 
-	INIT_DELAYED_WORK(&cm->fullbatt_vchk_work, fullbatt_vchk);
-
 	ret = power_supply_register(NULL, &cm->charger_psy);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot register charger-manager with name \"%s\"\n",
@@ -1757,8 +1670,6 @@ static bool cm_need_to_awake(void)
 
 static int cm_suspend_prepare(struct device *dev)
 {
-	struct charger_manager *cm = dev_get_drvdata(dev);
-
 	if (cm_need_to_awake())
 		return -EBUSY;
 
@@ -1770,7 +1681,6 @@ static int cm_suspend_prepare(struct device *dev)
 	if (cm_timer_set) {
 		cancel_work_sync(&setup_polling);
 		cancel_delayed_work_sync(&cm_monitor_work);
-		cancel_delayed_work(&cm->fullbatt_vchk_work);
 	}
 
 	return 0;
@@ -1795,31 +1705,6 @@ static void cm_suspend_complete(struct device *dev)
 
 	_cm_monitor(cm);
 
-	/* Re-enqueue delayed work (fullbatt_vchk_work) */
-	if (cm->fullbatt_vchk_jiffies_at) {
-		unsigned long delay = 0;
-		unsigned long now = jiffies + CM_JIFFIES_SMALL;
-
-		if (time_after_eq(now, cm->fullbatt_vchk_jiffies_at)) {
-			delay = (unsigned long)((long)now
-				- (long)(cm->fullbatt_vchk_jiffies_at));
-			delay = jiffies_to_msecs(delay);
-		} else {
-			delay = 0;
-		}
-
-		/*
-		 * Account for cm_suspend_duration_ms with assuming that
-		 * timer stops in suspend.
-		 */
-		if (delay > cm_suspend_duration_ms)
-			delay -= cm_suspend_duration_ms;
-		else
-			delay = 0;
-
-		queue_delayed_work(cm_wq, &cm->fullbatt_vchk_work,
-				   msecs_to_jiffies(delay));
-	}
 	device_set_wakeup_capable(cm->dev, false);
 }
 
@@ -1859,75 +1744,6 @@ static void __exit charger_manager_cleanup(void)
 }
 module_exit(charger_manager_cleanup);
 
-/**
- * find_power_supply - find the associated power_supply of charger
- * @cm: the Charger Manager representing the battery
- * @psy: pointer to instance of charger's power_supply
- */
-static bool find_power_supply(struct charger_manager *cm,
-			struct power_supply *psy)
-{
-	int i;
-	bool found = false;
-
-	for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
-		if (!strcmp(psy->name, cm->desc->psy_charger_stat[i])) {
-			found = true;
-			break;
-		}
-	}
-
-	return found;
-}
-
-/**
- * cm_notify_event - charger driver notify Charger Manager of charger event
- * @psy: pointer to instance of charger's power_supply
- * @type: type of charger event
- * @msg: optional message passed to uevent_notify fuction
- */
-void cm_notify_event(struct power_supply *psy, enum cm_event_types type,
-		     char *msg)
-{
-	struct charger_manager *cm;
-	bool found_power_supply = false;
-
-	if (psy == NULL)
-		return;
-
-	mutex_lock(&cm_list_mtx);
-	list_for_each_entry(cm, &cm_list, entry) {
-		found_power_supply = find_power_supply(cm, psy);
-		if (found_power_supply)
-			break;
-	}
-	mutex_unlock(&cm_list_mtx);
-
-	if (!found_power_supply)
-		return;
-
-	switch (type) {
-	case CM_EVENT_BATT_FULL:
-		fullbatt_handler(cm);
-		break;
-	case CM_EVENT_BATT_OUT:
-		battout_handler(cm);
-		break;
-	case CM_EVENT_BATT_IN:
-	case CM_EVENT_EXT_PWR_IN_OUT ... CM_EVENT_CHG_START_STOP:
-		misc_event_handler(cm, type);
-		break;
-	case CM_EVENT_UNKNOWN:
-	case CM_EVENT_OTHERS:
-		power_supply_changed(&cm->charger_psy);
-		break;
-	default:
-		dev_err(cm->dev, "%s: type not specified\n", __func__);
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(cm_notify_event);
-
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
 MODULE_DESCRIPTION("Charger Manager");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 29d9b19..22a8097 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -133,11 +133,10 @@ struct charger_regulator {
  * @psy_name: the name of power-supply-class for charger manager
  * @polling_mode:
  *	Determine which polling mode will be used
- * @fullbatt_vchkdrop_ms:
  * @fullbatt_vchkdrop_uV:
  *	Check voltage drop after the battery is fully charged.
- *	If it has dropped more than fullbatt_vchkdrop_uV after
- *	fullbatt_vchkdrop_ms, CM will restart charging.
+ *	If it has dropped more than fullbatt_vchkdrop_uV
+ *	CM will restart charging.
  * @fullbatt_uV: voltage in microvolt
  *	If VBATT >= fullbatt_uV, it is assumed to be full.
  * @fullbatt_soc: state of Charge in %
@@ -174,7 +173,6 @@ struct charger_desc {
 	enum polling_modes polling_mode;
 	unsigned int polling_interval_ms;
 
-	unsigned int fullbatt_vchkdrop_ms;
 	unsigned int fullbatt_vchkdrop_uV;
 	unsigned int fullbatt_uV;
 	unsigned int fullbatt_soc;
@@ -212,9 +210,6 @@ struct charger_desc {
  * @charger_stat: array of power_supply for chargers
  * @tzd_batt : thermal zone device for battery
  * @charger_enabled: the state of charger
- * @fullbatt_vchk_jiffies_at:
- *	jiffies at the time full battery check will occur.
- * @fullbatt_vchk_work: work queue for full battery check
  * @emergency_stop:
  *	When setting true, stop charging
  * @psy_name_buf: the name of power-supply-class for charger manager
@@ -235,9 +230,6 @@ struct charger_manager {
 
 	bool charger_enabled;
 
-	unsigned long fullbatt_vchk_jiffies_at;
-	struct delayed_work fullbatt_vchk_work;
-
 	int emergency_stop;
 
 	char psy_name_buf[PSY_NAME_MAX + 1];
@@ -247,11 +239,4 @@ struct charger_manager {
 	u64 charging_end_time;
 };
 
-#ifdef CONFIG_CHARGER_MANAGER
-extern void cm_notify_event(struct power_supply *psy,
-				enum cm_event_types type, char *msg);
-#else
-static inline void cm_notify_event(struct power_supply *psy,
-				enum cm_event_types type, char *msg) { }
-#endif
 #endif /* _CHARGER_MANAGER_H */
-- 
1.7.9.5

