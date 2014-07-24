Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbaGXNYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:24:21 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:53703 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbaGXNYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:24:20 -0400
Date: Thu, 24 Jul 2014 10:24:06 -0300
From: Lucas Tanure <tanure@linux.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        kernelnewbies <kernelnewbies@kernelnewbies.org>
Subject: [PATCH] powerpc: fix wrong defintion in boot/io.h
Message-ID: <20140724132406.GA2159@ttmp-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix wrong __IO_H definition in boot/io.h

Reported-by: Fernando Silveira <fsilveira@gmail.com>
Signed-off-by: Lucas Tanure <tanure@linux.com>
---
 arch/powerpc/boot/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/io.h b/arch/powerpc/boot/io.h
index 7c09f48..394da55 100644
--- a/arch/powerpc/boot/io.h
+++ b/arch/powerpc/boot/io.h
@@ -1,5 +1,5 @@
 #ifndef _IO_H
-#define __IO_H
+#define _IO_H
 
 #include "types.h"
 
-- 
2.0.0

