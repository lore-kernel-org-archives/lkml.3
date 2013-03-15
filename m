Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3COPYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:24:20 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:59234 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761Ab3COPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:24:17 -0400
Message-ID: <1363361050.1335.112.camel@x61.thuisdomein>
Subject: [PATCH] misc: Remove max8997-muic.o Makefile line again
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 16:24:10 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2013 15:24:11.0118 (UTC) FILETIME=[24C4E0E0:01CE2191]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 20259849bb1ac1ffb0156eb359810e8b99cb644d ("VMCI: Some header and
config files.") readded this Makefile line. Remove it again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Bravely untested.

 drivers/misc/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 35a1463..3e2faa0 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -49,6 +49,5 @@ obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
-obj-$(CONFIG_MAX8997_MUIC)	+= max8997-muic.o
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
-- 
1.7.11.7

