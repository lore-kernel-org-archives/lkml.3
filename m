Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3CDEGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:06:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32815 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240Ab3CDDna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:30 -0500
Message-Id: <20130304033717.804996924@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 103/153] doc, xen: Mention earlyprintk=xen in the documentation.
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 2482a92e7d17187301d7313cfe5021b13393a0b4 upstream.

The earlyprintk for Xen PV guests utilizes a simple hypercall
(console_io) to provide output to Xen emergency console.

Note that the Xen hypervisor should be booted with 'loglevel=all'
to output said information.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1361825650-14031-2-git-send-email-konrad.wilk@oracle.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -703,6 +703,7 @@ bytes respectively. Such letter suffixes
 
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
+			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
@@ -720,6 +721,8 @@ bytes respectively. Such letter suffixes
 			The VGA output is eventually overwritten by the real
 			console.
 
+			The xen output can only be used by Xen PV guests.
+
 	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
 			ekgdboc=kbd
 


