Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3GZEK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:10:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15531 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3GZEKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:10:25 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-5a-51f1f6af7345
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2] driver core: replace strict_strto*() with kstrto*()
Date: Fri, 26 Jul 2013 13:10:22 +0900
Message-id: <000201ce89b6$0c7e9ac0$257bd040$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6Jtd8dFhL5o+oATg2wuqSjwNcjeQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zfd313z4GGly6xGfRvHg9m8XlhZdY
	LS7vmsPmwOyxf+4ado++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKuHv3EVPBF5GKI+19TA2M
	3YJdjJwcEgImEt0HTjNC2GISF+6tZwOxhQSWMUqsW2sGU/O05SF7FyMXUHw6o8Tytj4WCOcX
	o8Sq7yvZQarYBNQkvnw5DGaLCJhKbHw/BWwqs4CTxM8tM1lAbGEBd4kDhy6AbWARUJVYM+0R
	M4jNK2Ap8fxnIyOELSjxY/I9FoheLYn1O48zQdjyEpvXvGWGuEhBYsfZ14wQu/Qklu68ywxR
	IyKx78U7RpDjJAQWsUvs7DvBCLFMQOLb5ENAQzmAErISmw5AzZGUOLjiBssERrFZSFbPQrJ6
	FpLVs5CsWMDIsopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJKZ6dzDePmB9iDEZaP1EZinR
	5HxgTOaVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gbH23IluW3bedplXH1+ferKlqEF9ju2sI/pb/kcp7stmXP7fIcvjcNRb8QnlN532T17wNnXW
	wW0st2y/LzC+XZJ0t5Z/V1F/wNovnwt0Juw+ksRxlf25XtiHb8567pG6JTvTd+3hW7UixZZt
	s3rgt9shNpLlP9ovGvzc7tojzNpVtPfXjtW+N/crsRRnJBpqMRcVJwIAvwYT9b8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoO76bx8DDQ7d47JoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZty9+4ip4ItIxZH2PqYGxm7BLkZODgkBE4mnLQ/ZIWwxiQv31rN1MXJxCAlMZ5RY
	3tbHAuH8YpRY9X0lWBWbgJrEly+HwWwRAVOJje+nMILYzAJOEj+3zGQBsYUF3CUOHLrABmKz
	CKhKrJn2iBnE5hWwlHj+s5ERwhaU+DH5HgtEr5bE+p3HmSBseYnNa94yQ1ykILHj7GtGiF16
	Ekt33mWGqBGR2PfiHeMERoFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeu
	l5yfu4kRHLPPpHYwrmywOMQowMGoxMOr4PQxUIg1say4MvcQowQHs5IIb8MxoBBvSmJlVWpR
	fnxRaU5q8SHGZKBPJzJLiSbnA9NJXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNT
	UwtSi2C2MHFwSjUwqjxbMGnLgvsSu+JW3l15K4T3R2bt0e0da+K6+qebpBf6dj6+kmJk1law
	8pcbxzdOvinvv/CHPtU2/P+76hmPvoSKeufCDV4pG/5cmZ0YXO1kXX43PyJHuOA7e+Wyzcet
	KnY5adsf3zn7xOV513W+P2tg4l2wdruJxAEvpoN2UjK2Gj84rDhClViKMxINtZiLihMBGu/i
	1h0DAAA=
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
Changes since v1:
- mechanically replaced strict_strto*() with kstrto*().

 drivers/base/core.c                  |    2 +-
 drivers/base/memory.c                |    4 ++--
 drivers/base/power/sysfs.c           |    2 +-
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

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
index 2b7813e..ddd14ce 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -469,7 +469,7 @@ store_soft_offline_page(struct device *dev,
 	u64 pfn;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (strict_strtoull(buf, 0, &pfn) < 0)
+	if (kstrtoull(buf, 0, &pfn) < 0)
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
 	if (!pfn_valid(pfn))
@@ -488,7 +488,7 @@ store_hard_offline_page(struct device *dev,
 	u64 pfn;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (strict_strtoull(buf, 0, &pfn) < 0)
+	if (kstrtoull(buf, 0, &pfn) < 0)
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
 	ret = memory_failure(pfn, 0, 0);
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index a53ebd2..03e089a 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -206,7 +206,7 @@ static ssize_t autosuspend_delay_ms_store(struct device *dev,
 	if (!dev->power.use_autosuspend)
 		return -EIO;
 
-	if (strict_strtol(buf, 10, &delay) != 0 || delay != (int) delay)
+	if (kstrtol(buf, 10, &delay) != 0 || delay != (int) delay)
 		return -EINVAL;
 
 	device_lock(dev);
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 5349575..634164d 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -281,7 +281,7 @@ static ssize_t regmap_map_write_file(struct file *file,
 	reg = simple_strtoul(start, &start, 16);
 	while (*start == ' ')
 		start++;
-	if (strict_strtoul(start, 16, &value))
+	if (kstrtoul(start, 16, &value))
 		return -EINVAL;
 
 	/* Userspace has been fiddling around behind the kernel's back */
-- 
1.7.10.4


