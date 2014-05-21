Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaEUOjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:39:39 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:43255 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaEUOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:39:37 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 2/3] xen blkif.h: fix comment typo in discard-alignment
Date: Wed, 21 May 2014 16:32:41 +0200
Message-Id: <1400682762-17429-3-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
References: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing 'n' to discard-alignment

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 include/xen/interface/io/blkif.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index 32ec05a..c33e1c4 100644
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
