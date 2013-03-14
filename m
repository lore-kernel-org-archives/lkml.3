Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3CNLDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:03:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3CNKhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 15/88] doc, xen: Mention 'earlyprintk=xen' in the documentation.
Date: Thu, 14 Mar 2013 10:35:08 +0000
Message-Id: <1363257381-15900-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/kernel-parameters.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a92c5eb..65f25d7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -760,6 +760,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
+			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
@@ -777,6 +778,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			The VGA output is eventually overwritten by the real
 			console.
 
+			The xen output can only be used by Xen PV guests.
+
 	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
 			ekgdboc=kbd
 
-- 
1.8.1.2

