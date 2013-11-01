Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3KACWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:22:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18761 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3KACV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:21:59 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-50-527310456097
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: update f2fs document
Date: Fri, 01 Nov 2013 11:21:15 +0900
Message-id: <1383272475-5023-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zY11XgeIgg/aHIhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZex++p654B9bxZVO
	qQbGY6xdjBwcEgImEt/6NLsYOYFMMYkL99azdTFycQgJLGOUePTiJAtEwkSiYeYsRojEIkaJ
	gzs7oaqamSQ+nX7NCDKJTUBbYvN+A5AGEQFmiQVTz4M1MAtMYJT4v+g92CRhoJollxaygdgs
	AqoSn/9eYgexeQXcJG6tecUMsU1bYtvziWDNEgK32SS+PVjHAtEgIPFt8iEWiLNlJTYdgKqX
	lDi44gbLBEbBBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFCAnDCDsZ7B6wPMSYDjZvI
	LCWanA8M4LySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4ASGdOtDGb1P3ep7JvCmbHE1szNmvLrVXdvOJPhucHf301kH60qqb3PPcg0QM2hvYJ70av6V
	uZPeBU+qkhA82bM89tD8HaxJt72ym9vWHC/4mqpu1nVTL37ZtYPHJ9vsi3l+abv+5azzFj/i
	3zq/Zg9Ozd5f0/Lr5HYRRjl5jtkpZmvX+/+f/ClpvRJLcUaioRZzUXEiACEbA75WAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAV1XgeIgg6tzBC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zY/fQ9c8E/toornVINjMdYuxg5OSQETCQaZs5ihLDFJC7cW8/WxcjFISSw
	iFHi4M5OKKeZSeLT6ddAVRwcbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAEsJANUsu
	LWQDsVkEVCU+/73EDmLzCrhJ3Frzihlim7bEtucTGScwci9gZFjFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJERzgz6R3MK5qsDjEKMDBqMTD6zCxKEiINbGsuDL3EKMEB7OSCK/WcqAQb0pi
	ZVVqUX58UWlOavEhxmSg7ROZpUST84HRl1cSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTE
	ktTs1NSC1CKYLUwcnMDwXHim7HeCrUOZFOeZDd/2fymam5Zd4O52rPwex6vPm+bH5r0r2Pi+
	817IRo0vlxs+HzVdLveuw1WU73TCq3dlHV5dL+K2hEy8dSTlf1peWRn7L99PFjvm+OltOHR9
	ypcN+UrPP5qfsdoRyv//0HGnTh7VjxfDP2lfP9OR22wbIeXpY6HZdTD8kBJLcUaioRZzUXEi
	AKt1PS20AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch describes the inline_xattr support in f2fs document.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/filesystems/f2fs.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 4c647c2..a3fe811 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -119,6 +119,7 @@ active_logs=%u         Support configuring the number of active logs. In the
                        Default number is 6.
 disable_ext_identify   Disable the extension list configured by mkfs, so f2fs
                        does not aware of cold files such as media files.
+inline_xattr           Enable the inline xattrs feature.
 
 ================================================================================
 DEBUGFS ENTRIES
-- 
1.8.4.474.g128a96c

