Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaAIMEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:04:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30577 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAIME1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:04:27 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-a6-52ce9048c7b5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: update documents and a MAINTAINERS entry
Date: Thu, 09 Jan 2014 21:03:06 +0900
Message-id: <1389268986-20014-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zY12PCeeCDPrmKVhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHq6QrWgoUSFVf3
	3mBpYGwT6WLk5JAQMJF4tvAhC4QtJnHh3nq2LkYuDiGBZYwS7680ssMUrd1/hhEiMZ1RYtLt
	2WAdQgLNTBLffqZ3MXJwsAloS2zebwASFhFgllgw9TxYPbPABEaJ/4veg9ULC9hLtB16xgpi
	swioSixaeZMZxOYVcJeYumsRE8QybYltzyeCNUsIPGaTuNo4F6pBQOLb5EMsIMskBGQlNh1g
	hqiXlDi44gbLBEbBBYwMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFCQrB3B+PtA9aHGJOB
	xk1klhJNzgeGcF5JvKGxmZGFqYmpsZG5pRlpwkrivEkPk4KEBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MK6Pkbtzynx5hRrb865l9jXSu69fqGItm91ap7T42YFre1ZFz9E/oOm0lVODcevS
	xs8cpSvrrrZIzlTiipW3yYzY5KRbt+EZ1+2QibxcvwpKH/CELCzJ/CV1/Xy69JQPWn+YxE4V
	qgswzp6/QKdYqbSfa/lWmxkyh+7eDdp/11vgh4DXYuObh5RYijMSDbWYi4oTARSiHkhXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV2PCeeCDBY1ylhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx6ukK1oKFEhVX995gaWBsE+li5OSQEDCRWLv/DCOELSZx4d56ti5GLg4h
	gemMEpNuz2YBSQgJNDNJfPuZ3sXIwcEmoC2xeb8BSFhEgFliwdTzjCD1zAITGCX+L3oPVi8s
	YC/RdugZK4jNIqAqsWjlTWYQm1fAXWLqrkVMEMu0JbY9n8g4gZF7ASPDKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzgAH8mtYNxZYPFIUYBDkYlHt4VxWeDhFgTy4orcw8xSnAwK4nwTm08
	FyTEm5JYWZValB9fVJqTWnyIMRlo+0RmKdHkfGD05ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DV
	OlBIID2xJDU7NbUgtQhmCxMHp1QDoyz/wxUnRA8uzC3o1J0mw9Kwk/H7HeGp4Zd36Fw+vmef
	vnS7pLxSS6XUpXsX1utVJb5Sm11/6LH3K+E+D9YrE6QPpSuutw7O2Jh/7n3WMR/GFuWDbHMm
	e9fG3rN3elA6N+DD48l/7658nzL3G4MMo56S53rjj0LfOufFPykQ3qe8QObcBLGVs5RYijMS
	DbWYi4oTAWqg5gW0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing some description of sysfs entries in
 - Documentation/ABI/testing/sysfs-fs-f2fs
 - Documentation/filesystems/f2fs.txt.

And it adds a maintained document entry of F2FS in MAINTAINERS.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 31 +++++++++++++++++++++++++++++++
 Documentation/filesystems/f2fs.txt      |  5 +++++
 MAINTAINERS                             |  1 +
 3 files changed, 37 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 31942ef..32b0809 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -24,3 +24,34 @@ Date:		July 2013
 Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
 Description:
 		 Controls the victim selection policy for garbage collection.
+
+What:		/sys/fs/f2fs/<disk>/reclaim_segments
+Date:		October 2013
+Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
+Description:
+		 Controls the issue rate of segment discard commands.
+
+What:		/sys/fs/f2fs/<disk>/ipu_policy
+Date:		November 2013
+Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
+Description:
+		 Controls the in-place-update policy.
+
+What:		/sys/fs/f2fs/<disk>/min_ipu_util
+Date:		November 2013
+Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
+Description:
+		 Controls the FS utilization condition for the in-place-update
+		 policies.
+
+What:		/sys/fs/f2fs/<disk>/max_small_discards
+Date:		November 2013
+Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
+Description:
+		 Controls the issue rate of small discard commands.
+
+What:		/sys/fs/f2fs/<disk>/max_victim_search
+Date:		January 2014
+Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
+Description:
+		 Controls the number of trials to find a victim segment.
diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 998e698..b8d2849 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -190,6 +190,11 @@ Files in /sys/fs/f2fs/<devname>
                               of the filesystem utilization, and used by
                               F2FS_IPU_UTIL and F2FS_IPU_SSR_UTIL policies.
 
+ max_victim_search	      This parameter controls the number of trials to
+			      find a victim segment when conducting SSR and
+			      cleaning operations. The default value is 4096
+			      which covers 8GB block address range.
+
 ================================================================================
 USAGE
 ================================================================================
diff --git a/MAINTAINERS b/MAINTAINERS
index d5e4ff3..bd58e8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3629,6 +3629,7 @@ W:	http://en.wikipedia.org/wiki/F2FS
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
 S:	Maintained
 F:	Documentation/filesystems/f2fs.txt
+F:	Documentation/ABI/testing/sysfs-fs-f2fs
 F:	fs/f2fs/
 F:	include/linux/f2fs_fs.h
 
-- 
1.8.4.474.g128a96c

