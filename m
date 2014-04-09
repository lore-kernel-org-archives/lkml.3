Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbaDIScQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:32:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52170 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933736AbaDIScM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:32:12 -0400
Message-ID: <53459226.2070002@linux.vnet.ibm.com>
Date: Wed, 09 Apr 2014 13:32:06 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linux-scsi <linux-scsi@vger.kernel.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rob@pochix.net>
Subject: [PATCH] Update Maintainers for IBM Power 842, vscsi, and vfc drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040918-7182-0000-0000-00000A49C440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the MAINTAINERS file to indicate the current maintainers
for the IBM Power 842 Compression driver, IBM Power Virtual SCSI
driver and the IBM Power Virtual FC Driver.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 MAINTAINERS |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS	2014-04-08 14:14:57.000000000 -0500
+++ linux/MAINTAINERS	2014-04-08 14:25:29.000000000 -0500
@@ -4358,7 +4358,7 @@
 F:	drivers/crypto/nx/
 
 IBM Power 842 compression accelerator
-M:	Robert Jennings <rcj@linux.vnet.ibm.com>
+M:	Nathan Fontenot <nfont@linux.vnet.ibm.com>
 S:	Supported
 F:	drivers/crypto/nx/nx-842.c
 F:	include/linux/nx842.h
@@ -4374,12 +4374,18 @@
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmveth.*
 
-IBM Power Virtual SCSI/FC Device Drivers
-M:	Robert Jennings <rcj@linux.vnet.ibm.com>
+IBM Power Virtual SCSI Device Drivers
+M:	Nathan Fontenot <nfont@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-F:	drivers/scsi/ibmvscsi/
-X:	drivers/scsi/ibmvscsi/ibmvstgt.c
+F:	drivers/scsi/ibmvscsi/ibmvscsi*
+F:	drivers/scsi/ibmvscsi/viosrp.h
+
+IBM Power Virtual FC Device Drivers
+M:	Brian King <brking@linux.vnet.ibm.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/ibmvscsi/ibmvfc*
 
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer

