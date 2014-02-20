Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaBTJOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:14:16 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63944 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbaBTJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:14:06 -0500
Message-ID: <1392887643.5070.44.camel@x220>
Subject: [PATCH 2/2] MAINTAINERS: mark Advansys Orphan
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Hans de Goede <hdegoede@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 20 Feb 2014 10:14:03 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2014 09:14:03.0994 (UTC) FILETIME=[19912BA0:01CF2E1C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox hasn't touched the Advansys driver since v2.6.29. I have
not been able to get Matthew to respond to a trivial patch I'd like to
see go in. Mark this driver Orphan and add this driver to Matthew's
CREDITS entry.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 CREDITS     | 2 +-
 MAINTAINERS | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index e371c55..4adbf38 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3805,7 +3805,7 @@ N: Matthew Wilcox
 E: matthew@wil.cx
 W: ftp://ftp.uk.linux.org/pub/linux/people/willy/
 D: Linux/PARISC hacker.  Filesystem hacker.  Random other hacking.  Custom
-D: PPC port hacking.
+D: PPC port hacking.  Advansys SCSI driver.
 
 N: G\"unter Windau
 E: gunter@mbfys.kun.nl
diff --git a/MAINTAINERS b/MAINTAINERS
index fb08dce..c45d72e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -426,9 +426,8 @@ S:	Supported
 F:	drivers/input/misc/adxl34x.c
 
 ADVANSYS SCSI DRIVER
-M:	Matthew Wilcox <matthew@wil.cx>
 L:	linux-scsi@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	Documentation/scsi/advansys.txt
 F:	drivers/scsi/advansys.c
 
-- 
1.8.5.3

