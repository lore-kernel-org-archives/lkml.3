Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3BKE3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 23:29:06 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:42479 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3BKE3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 23:29:05 -0500
Message-ID: <1360556941.4204.4.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 1/2] zram: remove unexistant discard from sysfs ABI doc
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Date: Sun, 10 Feb 2013 20:29:01 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
Both patches apply on top of the staging-next branch
of the staging tree.

 Documentation/ABI/testing/sysfs-block-zram | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index ec93fe3..4627c33 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -52,15 +52,6 @@ Description:
 		is freed. This statistic is applicable only when this disk is
 		being used as a swap disk.
 
-What:		/sys/block/zram<id>/discard
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The discard file is read-only and specifies the number of
-		discard requests received by this device. These requests
-		provide information to block device regarding blocks which are
-		no longer used by filesystem.
-
 What:		/sys/block/zram<id>/zero_pages
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
-- 
1.7.11.7




