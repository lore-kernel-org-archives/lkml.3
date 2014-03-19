Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbaCSIEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:04:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64521 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbaCSIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:04:23 -0400
X-AuditID: cbfee68e-b7f566d000002344-cb-53294f6d329c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/5] f2fs: add missing documentation for dir_level
Date: Wed, 19 Mar 2014 17:02:08 +0900
Message-id: <1395216129-13656-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zQ91cf81ggw8/ZS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjjbP5G54BdbxZ1v
	G1kaGH+ydjFyckgImEis/XUMyhaTuHBvPVsXIxeHkMAyRoklL6aywRW9mswIkZjOKHHv5Eso
	p5NJYu+Hk+xdjBwcbALaEpv3G4A0iAgwSyyYeh6shllgAqPE/0XvWUASwgJOEn1fO5hA6lkE
	VCUenPMDCfMKuEtMmd3JCLFMW2Lb84lgNqeAh8ShmxeYQWwhoJqnb6+wgMyUEPjOJvHq91Sw
	s1kEBCS+TT7EAjJTQkBWYtMBZog5khIHV9xgmcAovICRYRWjaGpBckFxUnqRkV5xYm5xaV66
	XnJ+7iZGSMj27WC8ecD6EGMy0LiJzFKiyfnAkM8riTc0NjOyMDUxNTYytzQjTVhJnHfRw6Qg
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzLTXLWGaXMmPqyUF+go3Jr+o483pfZbisCJV4Y
	rVnqEL/Nwmxh6w0jd32ryGnz+G/ePvHmR/qqBdbTFz18pjFL5cnlg3J/3PsLPq+dsr/aIkfy
	ckWy7Gq2jYJ3j3FYfWJ/zJM3j3fF8ogKdWsxnstMK9N3patVHmzj8/H9mZz/3zk06suDqnNK
	LMUZiYZazEXFiQCJ/nCjbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd1cf81gg7lPpSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w42z+RueAXW8WdbxtZGhh/snYxcnJICJhIrH01mRHCFpO4cG89WxcjF4eQ
	wHRGiXsnXzJCOJ1MEns/nGTvYuTgYBPQlti83wCkQUSAWWLB1PNgNcwCExgl/i96zwKSEBZw
	kuj72sEEUs8ioCrx4JwfSJhXwF1iyuxOqGXaEtueTwSzOQU8JA7dvMAMYgsB1Tx9e4VlAiPv
	AkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBEfFMagfjygaLQ4wCHIxKPLwHojSChVgT
	y4orcw8xSnAwK4nwCt8FCvGmJFZWpRblxxeV5qQWH2JMBjpqIrOUaHI+MFrzSuINjU3MjCyN
	zCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoExfsn5Bn/ZxTtX1oZ95pKSYr2r
	k3E5NITzS/NMF/PzYkejOouPv726U8TV48vBu/kLrrTsi3h1Uf3FkZ4HMpctvfd3SJ069sW7
	JW7K4e27TtoxbytPVVDh0Hd4MZ/1dbbjvAtv/7ku3ZdRPH1iYWvOhaqzwWYHXdgVt/wxZahV
	m1fi1+b+sXytEktxRqKhFnNRcSIAkspSgswCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing dir_level documentation.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 4ac2c25..62dd725 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -56,6 +56,12 @@ Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
 Description:
 		 Controls the number of trials to find a victim segment.
 
+What:		/sys/fs/f2fs/<disk>/dir_level
+Date:		March 2014
+Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
+Description:
+		 Controls the directory level for large directory.
+
 What:		/sys/fs/f2fs/<disk>/ram_thresh
 Date:		March 2014
 Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
-- 
1.8.4.474.g128a96c

