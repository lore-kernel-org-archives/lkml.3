Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3DBRhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:37:40 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:47795 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758116Ab3DBRhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:37:37 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        olof@lixom.net
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] MAINTAINERS: Add maintainer for LPC32xx
Date: Tue,  2 Apr 2013 19:37:11 +0200
Message-Id: <1364924231-18591-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Roland Stigge as maintainer for NXP LPC32xx.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.orig/MAINTAINERS
+++ linux-2.6/MAINTAINERS
@@ -4941,6 +4941,12 @@ W:	logfs.org
 S:	Maintained
 F:	fs/logfs/
 
+LPC32XX MACHINE SUPPORT
+M:	Roland Stigge <stigge@antcom.de>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/mach-lpc32xx/
+
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 M:	Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
 M:	Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
