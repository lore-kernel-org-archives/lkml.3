Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaBJQul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:50:41 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:43494 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaBJQui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:50:38 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstAo5SQMel8AXawDOUvwr8pxjMon91SD6m7JJcBA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 2/3] xen blkif.h: fix comment typo in discard-alignment
Date: Mon, 10 Feb 2014 17:50:26 +0100
Message-Id: <1392051027-29516-3-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392051027-29516-1-git-send-email-olaf@aepfle.de>
References: <1392051027-29516-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing 'n' to discard-alignment

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 include/xen/interface/io/blkif.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index ae665ac..19ebcc5 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -86,7 +86,7 @@ typedef uint64_t blkif_sector_t;
  *     Interface%20manuals/100293068c.pdf
  * The backend can optionally provide three extra XenBus attributes to
  * further optimize the discard functionality:
- * 'discard-aligment' - Devices that support discard functionality may
+ * 'discard-alignment' - Devices that support discard functionality may
  * internally allocate space in units that are bigger than the exported
  * logical block size. The discard-alignment parameter indicates how many bytes
  * the beginning of the partition is offset from the internal allocation unit's
