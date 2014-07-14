Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaGNPST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:18:19 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48412 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbaGNPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 06/38] x86: clean-up Kbuild file - drop unused assignments
Date: Mon, 14 Jul 2014 17:08:34 +0200
Message-Id: <1405350546-28467-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop unused assignment in Kbuild file.
The unistd* files are exported using the Kbuild file in uapi/*
and the assignments in this file was left-overs from the past.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/x86/include/asm/Kbuild | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 3ca9762..3221167 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -1,9 +1,3 @@
-
-
-genhdr-y += unistd_32.h
-genhdr-y += unistd_64.h
-genhdr-y += unistd_x32.h
-
 generic-y += clkdev.h
 generic-y += early_ioremap.h
 generic-y += cputime.h
-- 
1.9.3

