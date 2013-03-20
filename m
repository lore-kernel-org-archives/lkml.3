Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3CTML5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:11:57 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:40233 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab3CTML4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:11:56 -0400
Date: Wed, 20 Mar 2013 13:11:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Massimo Dal Zotto <dz@debian.org>
Subject: MAINTAINERS: i8k driver is orphan
Message-ID: <20130320131145.54a99f99@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Massimo Dal Zotto stopped maintaining the i8k driver several years
ago, so move his name from MAINTAINERS to CREDITS.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 CREDITS     |    4 ++++
 MAINTAINERS |    4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- linux-3.9-rc3.orig/CREDITS	2013-03-20 11:53:43.810557616 +0100
+++ linux-3.9-rc3/CREDITS	2013-03-20 13:07:57.630663188 +0100
@@ -761,6 +761,10 @@ S: Northampton
 S: NN1 3QT
 S: United Kingdom
 
+N: Massimo Dal Zotto
+E: dz@debian.org
+D: i8k Dell laptop SMM driver
+
 N: Uwe Dannowski
 E: Uwe.Dannowski@ira.uka.de
 W: http://i30www.ira.uka.de/~dannowsk/
--- linux-3.9-rc3.orig/MAINTAINERS	2013-03-20 12:37:24.511191296 +0100
+++ linux-3.9-rc3/MAINTAINERS	2013-03-20 13:01:58.264354299 +0100
@@ -2435,9 +2435,7 @@ S:	Maintained
 F:	drivers/platform/x86/dell-laptop.c
 
 DELL LAPTOP SMM DRIVER
-M:	Massimo Dal Zotto <dz@debian.org>
-W:	http://www.debian.org/~dz/i8k/
-S:	Maintained
+S:	Orphan
 F:	drivers/char/i8k.c
 F:	include/uapi/linux/i8k.h
 


-- 
Jean Delvare
