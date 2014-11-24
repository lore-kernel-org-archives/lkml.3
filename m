Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaKXGR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:17:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10535 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaKXGRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:17:20 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-dd-5472cd630256
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v6 9/10]  xfstests: fsstress: Add fallocate insert range
Date: Mon, 24 Nov 2014 15:17:06 +0900
Message-id: <003201d007ae$45a8d1e0$d0fa75a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAHrZ0lJ+i1goQUT7i/zI5/Uk3QJw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkRDf5bFGIQWOrhMXSiZeYLbYcu8do
	MXPeHTaLPXtPslhc3jWHzaK15ye7xaK+W4wO7B6nFkl4NJ05yuyx+sJWRo++LasYPT5vkgtg
	jeKySUnNySxLLdK3S+DK+HFoLnPBLNGKq4s6GBsYfwp0MXJySAiYSPQceMYCYYtJXLi3nq2L
	kYtDSGApo8Sst88YYYom74RJTGeUuN73mgXC+cso8ernNqYuRg4ONgFtiT9bREEaRARcJebd
	/c4IUsMMMuni4ydgk4QFPCQ2PbvPCmKzCKhKTF54mw3E5hWwlPg7axIzhC0o8WPyPbCTmAW0
	JNbvPM4EYctLbF7zlhniIgWJHWdfM0Is05No7nzNBlEjIrHvxTuoqy+xS6w9GAuxS0Di2+RD
	LCB3SgjISmw6ADVGUuLgihssExjFZiHZPAvJ5llINs9CsmEBI8sqRtHUguSC4qT0IhO94sTc
	4tK8dL3k/NxNjMBoPP3v2YQdjPcOWB9iFOBgVOLh/bCxKESINbGsuDL3EKMp0EUTmaVEk/OB
	MZ9XEm9obGZkYWpiamxkbmmmJM77WupnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGczPG
	iPCTgjetz36fHLMza0e9yYRpYjbd6a9O8G00XnVml1LufttTctMitj7+MOdKab12wkvjc7G7
	fJ/tPiR+wvlK95ezPPs/rK51vTf/fdOU7ZWXGldvYnNeG9d7wGvTh68XmLp/Zq5Rlfj2yf5T
	8pILvm5fEr8tDK6+9DSwc5lHG5eqSP/B5UosxRmJhlrMRcWJAB689SvBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd3ks0UhBrMOC1gsnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBk/Ds1lLpglWnF1UQdjA+NP
	gS5GTg4JAROJyTvXs0HYYhIX7oHYXBxCAtMZJa73vWaBcP4ySrz6uY2pi5GDg01AW+LPFlGQ
	BhEBV4l5d78zgtQwCyxllLj4+AkjSEJYwENi07P7rCA2i4CqxOSFt8E28ApYSvydNYkZwhaU
	+DH5HguIzSygJbF+53EmCFteYvOat8wQFylI7Dj7mhFimZ5Ec+drNogaEYl9L94xTmAUmIVk
	1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR/kxqB+PKBotDjAIc
	jEo8vB82FoUIsSaWFVfmHmKU4GBWEuE9+68wRIg3JbGyKrUoP76oNCe1+BCjKdCnE5mlRJPz
	gYkoryTe0NjEzMjSyNzQwsjYXEmc98bN3BAhgfTEktTs1NSC1CKYPiYOTqkGxsPSB7m/vH6p
	3bP3Y9zTUzf2nrDYHcngdu6XSHP1GtvMA/vi7jkWXf8oojHPw/XLF43jbzJ+p14wmzT54Lx/
	XG8jZPfs43F36eQvYWpWe+EQ0ijjf6B/yquLrqlrlt+999h+xsK6b1M3WbCL9/ndk/ydcujB
	PL3jSvs3lEg8iF+7//uThM2rpgspsRRnJBpqMRcVJwIAyqi04QwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds insert operation support for fsstress, which is
meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 ltp/fsstress.c | 19 ++++++++++++++++---
 src/global.h   |  4 ++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b56fe5c..aa3e0c3 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -72,6 +72,7 @@ typedef enum {
 	OP_PUNCH,
 	OP_ZERO,
 	OP_COLLAPSE,
+	OP_INSERT,
 	OP_READ,
 	OP_READLINK,
 	OP_RENAME,
@@ -170,6 +171,7 @@ void	mknod_f(int, long);
 void	punch_f(int, long);
 void	zero_f(int, long);
 void	collapse_f(int, long);
+void	insert_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	rename_f(int, long);
@@ -209,6 +211,7 @@ opdesc_t	ops[] = {
 	{ OP_PUNCH, "punch", punch_f, 1, 1 },
 	{ OP_ZERO, "zero", zero_f, 1, 1 },
 	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
+	{ OP_INSERT, "insert", insert_f, 1, 1 },
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
@@ -2176,6 +2179,7 @@ struct print_flags falloc_flags [] = {
 	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
 	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
+	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
 	{ -1, NULL}
 };
 
@@ -2227,10 +2231,11 @@ do_fallocate(int opno, long r, int mode)
 	off %= maxfsize;
 	len = (off64_t)(random() % (1024 * 1024));
 	/*
-	 * Collapse range requires off and len to be block aligned, make it
-	 * more likely to be the case.
+	 * Collapse/insert range requires off and len to be block aligned,
+	 * make it more likely to be the case.
 	 */
-	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && (opno % 2)) {
+	if ((mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)) &&
+		(opno % 2)) {
 		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
 		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
 	}
@@ -2656,6 +2661,14 @@ collapse_f(int opno, long r)
 }
 
 void
+insert_f(int opno, long r)
+{
+#ifdef HAVE_LINUX_FALLOC_H
+	do_fallocate(opno, r, FALLOC_FL_INSERT_RANGE);
+#endif
+}
+
+void
 read_f(int opno, long r)
 {
 	char		*buf;
diff --git a/src/global.h b/src/global.h
index 8180f66..f63246b 100644
--- a/src/global.h
+++ b/src/global.h
@@ -172,6 +172,10 @@
 #define FALLOC_FL_ZERO_RANGE		0x10
 #endif
 
+#ifndef FALLOC_FL_INSERT_RANGE
+#define FALLOC_FL_INSERT_RANGE		0x20
+#endif
+
 #endif /* HAVE_LINUX_FALLOC_H */
 
 #endif /* GLOBAL_H */
-- 
1.7.11-rc0

