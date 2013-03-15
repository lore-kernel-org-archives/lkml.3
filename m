Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3COUBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:01:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:49034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3COUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:01:37 -0400
Message-ID: <51437E35.6050903@infradead.org>
Date: Fri, 15 Mar 2013 13:01:57 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Graf <agraf@suse.de>, Stuart Yoder <stuart.yoder@freescale.com>
Subject: [PATCH] kconfig menu: move Virtualization drivers near other virtualization
 options
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Make virtualization drivers be logically grouped together
(physically near each other) in the kconfig menu by
moving "Virtualization drivers" to be near "Virtio drivers",
Microsort Hyper-V, and Xen driver support.

This is just a user-friendly, visual search change.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Stuart Yoder <stuart.yoder@freescale.com>
---
 drivers/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-39-rc2.orig/drivers/Kconfig
+++ lnx-39-rc2/drivers/Kconfig
@@ -118,6 +118,8 @@ source "drivers/vfio/Kconfig"
 
 source "drivers/vlynq/Kconfig"
 
+source "drivers/virt/Kconfig"
+
 source "drivers/virtio/Kconfig"
 
 source "drivers/hv/Kconfig"
@@ -142,8 +144,6 @@ source "drivers/remoteproc/Kconfig"
 
 source "drivers/rpmsg/Kconfig"
 
-source "drivers/virt/Kconfig"
-
 source "drivers/devfreq/Kconfig"
 
 source "drivers/extcon/Kconfig"
