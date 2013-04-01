Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3DAG5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:57:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62386 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab3DAG46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:56:58 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-97-51592fb8598f
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/9] f2fs: do not use duplicate names in a macro
Date: Mon, 01 Apr 2013 15:55:52 +0900
Message-id: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zfd0d+pGBBlP2W1lc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfF96Vy2gp1cFR8P
	rmFpYLzM0cXIySEhYCLx5PgZZghbTOLCvfVsXYxcHEICyxglTl59zNjFyAFWtOiMPUR8EaPE
	z4m97BBOG5PEpaub2ECK2AS0JTbvNwAZJCLALLFg6nlGkBpmgQmMEv8XvWcBSQgLOEhMbfjI
	BGKzCKhK/JrRzgZi8wq4S7z+/JcR4gpdidX/n4MtkBB4zCZxrvUfM0SDgMS3yYdYIC6Sldh0
	AOpqSYmDK26wTGAUXMDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJAT7dzDePWB9iDEZ
	aNxEZinR5HxgCOeVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgbHJkpeL4bb5q5JELttjuX/0V3A0fDohq33W3JNpesnE9gn/7T54nzTj9m3ymLd/
	bZzD+m0s2blLjUKatm04ZDZ9/6wpTmIXFwdK9L59oR1Sn1SbGLvfIE8y+uasvQcWvLRevGvz
	WvuEfFMJF2bj0+3VsdP9rGbf4T17z1/H2sxwg5vW+31r/iixFGckGmoxFxUnAgCvuIQkVwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd0d+pGBBqvvmVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jxfelctoKdXBUfD65haWC8zNHFyMEhIWAiseiMfRcjJ5ApJnHh3nq2LkYu
	DiGBRYwSPyf2skM4bUwSl65uYgNpYBPQlti83wCkQUSAWWLB1POMIDXMAhMYJf4ves8CkhAW
	cJCY2vCRCcRmEVCV+DWjnQ3E5hVwl3j9+S8jxDZdidX/n7NPYORewMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4wJ9J72Bc1WBxiFGAg1GJhzfiQkSgEGtiWXFl7iFGCQ5mJRFen29A
	Id6UxMqq1KL8+KLSnNTiQ4zJQNsnMkuJJucDoy+vJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhjXbDt0+9HpM4seirtYvfmQqOXmG3fi4bR7HvN/7HkrsDRD
	7tGB47Ud14zE6795Kvs2GnmEWUy3bXsQ/7OHxdTS/Itq2vWOTo09DpcKSo10Uz4tlVx57U5a
	ScjFTdoaDyv37OqQfuLm/XZCpl1BYMa5qJ2vxGp7Wx6sy7occNp2br3st8XKTolKLMUZiYZa
	zEXFiQCdqZIjtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A macro should not use duplicate parameter names.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index e399bd4..c0d7740 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -23,13 +23,13 @@
 	((t == CURSEG_HOT_NODE) || (t == CURSEG_COLD_NODE) ||		\
 	(t == CURSEG_WARM_NODE))
 
-#define IS_CURSEG(sbi, segno)						\
-	((segno == CURSEG_I(sbi, CURSEG_HOT_DATA)->segno) ||	\
-	 (segno == CURSEG_I(sbi, CURSEG_WARM_DATA)->segno) ||	\
-	 (segno == CURSEG_I(sbi, CURSEG_COLD_DATA)->segno) ||	\
-	 (segno == CURSEG_I(sbi, CURSEG_HOT_NODE)->segno) ||	\
-	 (segno == CURSEG_I(sbi, CURSEG_WARM_NODE)->segno) ||	\
-	 (segno == CURSEG_I(sbi, CURSEG_COLD_NODE)->segno))
+#define IS_CURSEG(sbi, seg)						\
+	((seg == CURSEG_I(sbi, CURSEG_HOT_DATA)->segno) ||	\
+	 (seg == CURSEG_I(sbi, CURSEG_WARM_DATA)->segno) ||	\
+	 (seg == CURSEG_I(sbi, CURSEG_COLD_DATA)->segno) ||	\
+	 (seg == CURSEG_I(sbi, CURSEG_HOT_NODE)->segno) ||	\
+	 (seg == CURSEG_I(sbi, CURSEG_WARM_NODE)->segno) ||	\
+	 (seg == CURSEG_I(sbi, CURSEG_COLD_NODE)->segno))
 
 #define IS_CURSEC(sbi, secno)						\
 	((secno == CURSEG_I(sbi, CURSEG_HOT_DATA)->segno /		\
-- 
1.8.1.3.566.gaa39828

