Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3GVIju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:39:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23730 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab3GVIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:39:48 -0400
X-AuditID: cbfee68e-b7f276d000002279-3f-51ecefd11530
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] kernel: replace strict_strto*() with kstrto*()
Date: Mon, 22 Jul 2013 17:39:44 +0900
Message-id: <000401ce86b7$0463f580$0d2be080$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6GtuOAETPVpLFfRUSj4NMI28hViw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zA92L798EGmxZJm0xZ/0aNovLCy+x
	WlzeNYfNgdnjxIzfLB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcbHRtOCwUMXmaQ+ZGhhv
	8ncxcnJICJhIPL4xixXCFpO4cG89WxcjF4eQwDJGiUcdm5lgir5+ngKVWMQosXfrLWaQhJDA
	L0aJ2a8SQGw2ATWJL18Os4PYIgK6Eque7wKrYRZwkvi5ZSYLiC0sYC/x8+BDMJtFQFViwcx+
	MJtXwFJi1/mJjBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zlhniIAWJHWdfM0Ls0pOY3PkdapeI
	xL4X7xhBDpUQmMcuceXDTiaIZQIS3yYfAhrKAZSQldh0AGqOpMTBFTdYJjCKzUKyehaS1bOQ
	rJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCER1beD8eYB60OMyUDrJzJLiSbn
	AyMyryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	CZtL5j5jL8xY/dYqZMnsb36f7aO+xOx/GJcWl/VxRn3b+Z8LmCLX/Hc73PA4Y0H98vVrpi2o
	ORR2u2SqyM6j515dX7VAZN/KtaejSr3020963L3rNflksebPO0/fNN/dnDftlvkq5XV73pTf
	b/xn5j7f7a7RrAKNXu3r3qu+Sfy9IZlaMKX7ywwlluKMREMt5qLiRAD2VHyFvgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgO7F928CDbaeEbeYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wB2qSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxjzLjYaFpwWKhi87SHTA2MN/m7GDk5JARMJL5+nsIGYYtJXLi3Hsjm4hASWMQosXfr
	LWaQhJDAL0aJ2a8SQGw2ATWJL18Os4PYIgK6Eque7wKrYRZwkvi5ZSYLiC0sYC/x8+BDMJtF
	QFViwcx+MJtXwFJi1/mJjBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zlhniIAWJHWdfM0Ls0pOY
	3PkdapeIxL4X7xgnMArMQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT8
	3E2M4Hh9Jr2DcVWDxSFGAQ5GJR7ehoA3gUKsiWXFlbmHGCU4mJVEeD1XAYV4UxIrq1KL8uOL
	SnNSiw8xJgN9OpFZSjQ5H5hK8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQ
	WgSzhYmDU6qBUTbLzfV/4lm9ZQaL/mtX/n9Zb+W4/5vsL9kJTW1PZjyKM75YU/Yrfl2exns/
	55MO0Spnrm4Ps5e862DwdP/SLX01jzRCXDKMHmorTk4u872dOclW8qXnstZ/IdlZn321323s
	vSdpZqdzzmG77UK3FWfU3TvM/opGbdyy3/L0N4ct01tPBWtcUWIpzkg01GIuKk4EAJLdZBwb	AwAA
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
 kernel/gcov/fs.c |    2 +-
 kernel/ksysfs.c  |    2 +-
 kernel/params.c  |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 9bd0934..7a7d2ee 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -74,7 +74,7 @@ static int __init gcov_persist_setup(char *str)
 {
 	unsigned long val;
 
-	if (strict_strtoul(str, 0, &val)) {
+	if (kstrtoul(str, 0, &val)) {
 		pr_warning("invalid gcov_persist parameter '%s'\n", str);
 		return 0;
 	}
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 6ada93c..9659d38 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -113,7 +113,7 @@ static ssize_t kexec_crash_size_store(struct kobject *kobj,
 	unsigned long cnt;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &cnt))
+	if (kstrtoul(buf, 0, &cnt))
 		return -EINVAL;
 
 	ret = crash_shrink_memory(cnt);
diff --git a/kernel/params.c b/kernel/params.c
index 440e65d..1f228a3 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -252,13 +252,13 @@ int parse_args(const char *doing,
 	EXPORT_SYMBOL(param_ops_##name)
 
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtol);
+STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(long, long, "%li", long, kstrtol);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
-- 
1.7.10.4


