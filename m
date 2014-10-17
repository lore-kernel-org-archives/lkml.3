Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaJQIrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:47:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbaJQIrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:47:40 -0400
From: WANG Chao <chaowang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org (open list:ABI/API)
Subject: [PATCH] Documentation/ABI/testing/sysfs-ibft: fix a typo
Date: Fri, 17 Oct 2014 16:47:26 +0800
Message-Id: <1413535647-17801-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct a sentence in Documentation/ABI/testing/sysfs-ibft.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 Documentation/ABI/testing/sysfs-ibft | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-ibft b/Documentation/ABI/testing/sysfs-ibft
index c2b7d11..cac3930 100644
--- a/Documentation/ABI/testing/sysfs-ibft
+++ b/Documentation/ABI/testing/sysfs-ibft
@@ -20,4 +20,4 @@ Date:		November 2007
 Contact:	Konrad Rzeszutek <ketuzsezr@darnok.org>
 Description:	The /sys/firmware/ibft/ethernetX directory will contain
 		files that expose the iSCSI Boot Firmware Table NIC data.
-		This can this can the IP address, MAC, and gateway of the NIC.
+		Usually this contains the IP address, MAC, and gateway of the NIC.
-- 
1.9.3

