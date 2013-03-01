Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3CAUWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:22:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3CATpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 24/77] doc, xen: Mention earlyprintk=xen in the documentation.
Date: Fri,  1 Mar 2013 11:44:09 -0800
Message-Id: <20130301194354.561762449@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/kernel-parameters.txt |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -754,6 +754,7 @@ bytes respectively. Such letter suffixes
 
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
+			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
@@ -771,6 +772,8 @@ bytes respectively. Such letter suffixes
 			The VGA output is eventually overwritten by the real
 			console.
 
+			The xen output can only be used by Xen PV guests.
+
 	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
 			ekgdboc=kbd
 


