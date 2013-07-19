Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804Ab3GSHXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:23:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30683 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3GSHX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:23:29 -0400
X-AuditID: cbfee68e-b7f276d000002279-8b-51e8e96fce4b
From: Jingoo Han <jg1.han@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] driver core: replace strict_strto*() with kstrto*()
Date: Fri, 19 Jul 2013 16:23:27 +0900
Message-id: <001a01ce8450$dcbd0bb0$96372310$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6EULumWxc+IkdMS366sDnXryHxWw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zQ938ly8CDSbtNrFoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBl7Pm0m7ngnVjF7Ktf2BoY
	9wp1MXJySAiYSCz9s4MZwhaTuHBvPVsXIxeHkMAyRomf336wwhRN7+mESixilOieMIMFwvnF
	KHHrzB12kCo2ATWJL18Og9kiAsYS/WdngdnMAk4SP7fMBGrg4BAWcJHYs5kFJMwioCrxsPU8
	E4jNK2Apcf7VDjYIW1Dix+R7LBCtWhLrdx5ngrDlJTaveQt1qYLEjrOvGSFW6UlcmrmXDaJG
	RGLfi3eMILdJCCxil1hz7TMTxDIBiW+TD4HdICEgK7HpANQcSYmDK26wTGAUm4Vk9Swkq2ch
	WT0LyYoFjCyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MUJiqm8H480D1ocYk4HWT2SWEk3O
	B8ZkXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	Y/4Z5DJ4vz0Ut0rCtThUNOTMllkNsivbLJ5WWi7NMFA795Vh9b2DC3v9ZDes8nFuO6RbJJMd
	1fbuz2r2pwrCTzivh0suZZhrE2nI8Y49KjTp3ZEbVXk9/5dfXcl1dbvCf/WslrcvDgvbLjT5
	Nst6lsCe2bbCKY3Xr/zdZcs5XWeFhMqkz2ceK7EUZyQaajEXFScCAF0WBrm/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgG7+yxeBBl+eGFg0L17PZnF54SVW
	i8u75rA5MHvsn7uG3aNvyypGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCesYM/Z82s1c8E6sYvbVL2wNjHuFuhg5OSQETCSm93SyQdhiEhfurQeyuTiEBBYxSnRP
	mMEC4fxilLh15g47SBWbgJrEly+HwWwRAWOJ/rOzwGxmASeJn1tmAjVwcAgLuEjs2cwCEmYR
	UJV42HqeCcTmFbCUOP9qBxuELSjxY/I9FohWLYn1O48zQdjyEpvXvGWGOEhBYsfZ14wQq/Qk
	Ls3cywZRIyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10v
	OT93EyM4Yp9J7WBc2WBxiFGAg1GJh/fBl+eBQqyJZcWVuYcYJTiYlUR4fyW/CBTiTUmsrEot
	yo8vKs1JLT7EmAz06URmKdHkfGAyySuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2
	ampBahHMFiYOTqkGxvi2q2zS7SfErZ0nXn3O47ZB3OuKwMNY04BtD1hVRZT2XnjvsbhlQlrR
	DDujfXcMOw4dvf9+fQvPPiOfwm1mthe+TZhQlMTt+bdN8tOLhwsaTlkfux89R0OA9dNyPYXO
	3vLr3izaT9ZKqOfMEOP73uIudiJ1jsibc3MjlEXOz258Kfwg95TQRiWW4oxEQy3mouJEAGPn
	Fl0cAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strto*() is not preferred, because
strict_strto*() is obsolete. Thus, kstrto*() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/base/core.c                  |    2 +-
 drivers/base/memory.c                |   10 ++++++----
 drivers/base/power/sysfs.c           |    7 ++++++-
 drivers/base/regmap/regmap-debugfs.c |    5 +++--
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8856d74..edfbf05 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -38,7 +38,7 @@ long sysfs_deprecated = 0;
 #endif
 static __init int sysfs_deprecated_setup(char *arg)
 {
-	return strict_strtol(arg, 10, &sysfs_deprecated);
+	return kstrtol(arg, 10, &sysfs_deprecated);
 }
 early_param("sysfs.deprecated", sysfs_deprecated_setup);
 #endif
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 2b7813e..d0817fb 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -469,8 +469,9 @@ store_soft_offline_page(struct device *dev,
 	u64 pfn;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (strict_strtoull(buf, 0, &pfn) < 0)
-		return -EINVAL;
+	ret = kstrtoull(buf, 0, &pfn);
+	if (ret < 0)
+		return ret;
 	pfn >>= PAGE_SHIFT;
 	if (!pfn_valid(pfn))
 		return -ENXIO;
@@ -488,8 +489,9 @@ store_hard_offline_page(struct device *dev,
 	u64 pfn;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (strict_strtoull(buf, 0, &pfn) < 0)
-		return -EINVAL;
+	ret = kstrtoull(buf, 0, &pfn);
+	if (ret < 0)
+		return ret;
 	pfn >>= PAGE_SHIFT;
 	ret = memory_failure(pfn, 0, 0);
 	return ret ? ret : count;
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index a53ebd2..e0a3877 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -202,11 +202,16 @@ static ssize_t autosuspend_delay_ms_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t n)
 {
 	long delay;
+	int ret;
 
 	if (!dev->power.use_autosuspend)
 		return -EIO;
 
-	if (strict_strtol(buf, 10, &delay) != 0 || delay != (int) delay)
+	ret = kstrtol(buf, 10, &delay);
+	if (ret)
+		return ret;
+
+	if (delay != (int) delay)
 		return -EINVAL;
 
 	device_lock(dev);
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 5349575..664a75e 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -281,8 +281,9 @@ static ssize_t regmap_map_write_file(struct file *file,
 	reg = simple_strtoul(start, &start, 16);
 	while (*start == ' ')
 		start++;
-	if (strict_strtoul(start, 16, &value))
-		return -EINVAL;
+	ret = kstrtoul(start, 16, &value);
+	if (ret)
+		return ret;
 
 	/* Userspace has been fiddling around behind the kernel's back */
 	add_taint(TAINT_USER, LOCKDEP_STILL_OK);
-- 
1.7.10.4


