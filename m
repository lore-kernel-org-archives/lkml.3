Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab3BEJpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:45:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56257 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3BEJpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:45:47 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-58-5110d4c9d8a0
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rafael.j.wysocki@intel.com, rajagopal.venkat@linaro.org, nm@ti.com,
        a.kesavan@samsung.com, jonghwa3.lee@samsung.com,
        sangjung.woo@samsung.com, myungjoo.ham@gmail.com
Subject: [PATCH] PM / devfreq: add comments and Documentation
Date: Tue, 05 Feb 2013 18:45:55 +0900
Message-id: <1360057555-10279-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t8zTd2TVwQCDQ5sELS4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVsf3KOqeCtVMXc5wUNjFPFuhg5OSQETCQ+XdrGDGGL
	SVy4t54NxBYSWMYo8eu9AUzNm+/HmLoYuYDi0xklrvx5xwLhtDBJrLy0mRWkik1AV2Lrhrss
	ILaIgJXE6f8dzCBFzAJrGSV+nrwDlhAWsJU41fAVzGYRUJVYf/422DpeAQ+Jl/1f2SHWKUj8
	OrKKFaRZQuAAm8SuaZuYIBoEJL5NPgTUzAGUkJXYdADqbEmJgytusExgFFzAyLCKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIyS4pHYwrmywOMQowMGoxMP74zJ/oBBrYllxZe4hRgkOZiUR
	3o83gEK8KYmVValF+fFFpTmpxYcYk4GWT2SWEk3OBwZ+Xkm8obGBsaGhpaGZqaWpAWnCSuK8
	jKeeBAgJpCeWpGanphakFsFsYeLglGpgdG19k93CKTFZNrHA+VP/WvuLH0pi03lnCxiY5TAz
	pkyeYeuRduxBxiG72iV++oEabRpbtSW8e61W8BRGrepTCWTZas8vcFfqh9rGO3krWx67tLv8
	OXa35bKyzN6UqtJHWp9mrH/3c1KmwMTC/wUfyzZzce7O/iApOTkseJaN4IMF/5axTL6mxFKc
	kWioxVxUnAgATAbkqXICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xoO7JKwKBBt13WCwu75rDZvG59wij
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ25+cYyp4K1Ux
	93lBA+NUsS5GTg4JAROJN9+PMUHYYhIX7q1n62Lk4hASmM4oceXPOxYIp4VJYuWlzawgVWwC
	uhJbN9xlAbFFBKwkTv/vYAYpYhZYyyjx8+QdsISwgK3EqYavYDaLgKrE+vO32UBsXgEPiZf9
	X9kh1ilI/DqyinUCI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHB+0xqB+PKBotD
	jAIcjEo8vD8u8wcKsSaWFVfmHmKU4GBWEuH9eAMoxJuSWFmVWpQfX1Sak1p8iDEZaPtEZinR
	5HxgZOWVxBsam5gZWRqZGZuYGxuTJqwkzst46kmAkEB6YklqdmpqQWoRzBYmDk6pBsZ5Qv/m
	Z1t3+z1s6cpaI/7U5sVVje3RCyxP5uaEM3R+5O/lnvXFOkLi2bOvi55knDH5P8FpsajksePH
	xRVfMU4u7pu5K9hk/sE3cTcmyL+91tufs45hpYjP6u8rln/uaG9nX9j657+QQV3gj6VsqrYX
	/aWVt2/7dfuPLHuqB9c6yTVbfm9Y8qZeiaU4I9FQi7moOBEAF4sKCaICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Added missing ABI documents
- Added comments to clarify the objectives of functions

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 Documentation/ABI/testing/sysfs-class-devfreq |   20 ++++++++++++++++++++
 drivers/devfreq/devfreq.c                     |   10 ++++++++++
 include/linux/devfreq.h                       |    2 ++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
index 0ba6ea2..ee39aca 100644
--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -78,3 +78,23 @@ Contact:	Nishanth Menon <nm@ti.com>
 Description:
 		The /sys/class/devfreq/.../available_governors shows
 		currently available governors in the system.
+
+What:		/sys/class/devfreq/.../min_freq
+Date:		January 2013
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/devfreq/.../min_freq shows and stores
+		the minimum frequency requested by users. It is 0 if
+		the user does not care. min_freq overrides the
+		frequency requested by governors.
+
+What:		/sys/class/devfreq/.../max_freq
+Date:		January 2013
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/devfreq/.../max_freq shows and stores
+		the maximum frequency requested by users. It is 0 if
+		the user does not care. max_freq overrides the
+		frequency requested by governors and min_freq.
+		The max_freq overrides min_freq because max_freq may be
+		used to throttle devices to avoid overheating.
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index abfa14d..44c4079 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -527,6 +527,8 @@ EXPORT_SYMBOL(devfreq_add_device);
 /**
  * devfreq_remove_device() - Remove devfreq feature from a device.
  * @devfreq:	the devfreq instance to be removed
+ *
+ * The opposite of devfreq_add_device().
  */
 int devfreq_remove_device(struct devfreq *devfreq)
 {
@@ -542,6 +544,10 @@ EXPORT_SYMBOL(devfreq_remove_device);
 /**
  * devfreq_suspend_device() - Suspend devfreq of a device.
  * @devfreq: the devfreq instance to be suspended
+ *
+ * This function is intended to be called by the pm callbacks
+ * (e.g., runtime_suspend, suspend) of the device driver that
+ * holds the devfreq.
  */
 int devfreq_suspend_device(struct devfreq *devfreq)
 {
@@ -559,6 +565,10 @@ EXPORT_SYMBOL(devfreq_suspend_device);
 /**
  * devfreq_resume_device() - Resume devfreq of a device.
  * @devfreq: the devfreq instance to be resumed
+ *
+ * This function is intended to be called by the pm callbacks
+ * (e.g., runtime_resume, resume) of the device driver that
+ * holds the devfreq.
  */
 int devfreq_resume_device(struct devfreq *devfreq)
 {
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index e83ef39..04ad61d 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -181,6 +181,8 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
 				  const char *governor_name,
 				  void *data);
 extern int devfreq_remove_device(struct devfreq *devfreq);
+
+/* Supposed to be called by PM_SLEEP/PM_RUNTIME callbacks */
 extern int devfreq_suspend_device(struct devfreq *devfreq);
 extern int devfreq_resume_device(struct devfreq *devfreq);
 
-- 
1.7.5.4

