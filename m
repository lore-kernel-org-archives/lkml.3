Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab3BYWOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:14:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759830Ab3BYWON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:14:13 -0500
Date: Mon, 25 Feb 2013 14:13:01 -0800
From: tip-bot for Konrad Rzeszutek Wilk <tipbot@zytor.com>
Message-ID: <tip-2482a92e7d17187301d7313cfe5021b13393a0b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, stable@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, stable@vger.kernel.org,
        hpa@linux.intel.com
In-Reply-To: <1361825650-14031-2-git-send-email-konrad.wilk@oracle.com>
References: <1361825650-14031-2-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] doc, xen: Mention 'earlyprintk=xen'
  in the documentation.
Git-Commit-ID: 2482a92e7d17187301d7313cfe5021b13393a0b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 25 Feb 2013 14:13:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2482a92e7d17187301d7313cfe5021b13393a0b4
Gitweb:     http://git.kernel.org/tip/2482a92e7d17187301d7313cfe5021b13393a0b4
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Mon, 25 Feb 2013 15:54:08 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 25 Feb 2013 13:41:18 -0800

doc, xen: Mention 'earlyprintk=xen' in the documentation.

The earlyprintk for Xen PV guests utilizes a simple hypercall
(console_io) to provide output to Xen emergency console.

Note that the Xen hypervisor should be booted with 'loglevel=all'
to output said information.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1361825650-14031-2-git-send-email-konrad.wilk@oracle.com
Cc: <stable@vger.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6c72381..c4cc199 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -754,6 +754,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
+			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
@@ -771,6 +772,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			The VGA output is eventually overwritten by the real
 			console.
 
+			The xen output can only be used by Xen PV guests.
+
 	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
 			ekgdboc=kbd
 
