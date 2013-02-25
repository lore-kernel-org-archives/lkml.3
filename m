Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab3BYUy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:54:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33518 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3BYUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:54:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] xen/documentation: Mention 'earlyprintk=xen' in the documentation.
Date: Mon, 25 Feb 2013 15:54:08 -0500
Message-Id: <1361825650-14031-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1361825650-14031-1-git-send-email-konrad.wilk@oracle.com>
References: <1361825650-14031-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The earlyprintk for Xen PV guests utilizes a simple hypercall
(console_io) to provide output to Xen emergency console.

Note that the Xen hypervisor should be booted with 'loglevel=all'
to output said information.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/kernel-parameters.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7660877..73d51ed 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -757,6 +757,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
+			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
@@ -774,6 +775,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			The VGA output is eventually overwritten by the real
 			console.
 
+			The xen output can only be used by Xen PV guests.
+
 	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
 			ekgdboc=kbd
 
-- 
1.8.0.2

