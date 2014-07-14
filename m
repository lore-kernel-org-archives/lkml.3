Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaGNPJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:09:37 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48387 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbaGNPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:18 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Jonas Bonn <jonas@southpole.se>,
        openrisc <linux@openrisc.net>, David Howells <dhowells@redhat.com>
Subject: [PATCH 02/38] openrisc: drop ucontext from list exported headers
Date: Mon, 14 Jul 2014 17:08:30 +0200
Message-Id: <1405350546-28467-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ucontext.h is already specified in include/uapi/asm-generic/Kbuild
so this is redundant.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: openrisc <linux@lists.openrisc.net>
Cc: David Howells <dhowells@redhat.com>
---
 arch/openrisc/include/asm/Kbuild | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 480af0d..4a80261 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -1,6 +1,3 @@
-
-header-y += ucontext.h
-
 generic-y += atomic.h
 generic-y += auxvec.h
 generic-y += barrier.h
-- 
1.9.3

