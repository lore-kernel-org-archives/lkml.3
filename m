Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3JCR0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:26:39 -0400
Received: from mout.web.de ([212.227.15.3]:62106 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab3JCR0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:26:36 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] kconfig: add short explanation to SYMBOL_WRITE
Date: Thu, 03 Oct 2013 19:24:18 +0200
Message-ID: <1756247.WUjWzOprtK@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:NOqKyOXmxZ9wniWigsBmRu5zUiMXHToquYCKDxqFpl3HgLcJTLG
 fvBlo1yDkt+1KH842KsGf2ReoGRzfEgwsE/ZFq0Q6tebXog9rdphkIo806zZwSFdb+9pEKs
 VhegcvYTGKHVFnUfc1rSc6pi+p61ZOlCgEXLJuO3CAh2PABYZ7Q1VVxndRI1rGnTwEqJ7/x
 iBDdjflgCDIeUo/HM2KiQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Thu, 3 Oct 2013 17:21:23 +0200
Subject: [PATCH v2 1/5] kconfig: add short explanation to SYMBOL_WRITE

replace the question mark in the comment after SYMBOL_WRITE with an explanation

Signed-off-by: Martin Walch <walch.martin@web.de>
---
 scripts/kconfig/expr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index df198a5..ba663e1 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -93,7 +93,7 @@ struct symbol {
 #define SYMBOL_CHOICEVAL  0x0020  /* used as a value in a choice block */
 #define SYMBOL_VALID      0x0080  /* set when symbol.curr is calculated */
 #define SYMBOL_OPTIONAL   0x0100  /* choice is optional - values can be 'n' */
-#define SYMBOL_WRITE      0x0200  /* ? */
+#define SYMBOL_WRITE      0x0200  /* write symbol to file (KCONFIG_CONFIG) */
 #define SYMBOL_CHANGED    0x0400  /* ? */
 #define SYMBOL_AUTO       0x1000  /* value from environment variable */
 #define SYMBOL_CHECKED    0x2000  /* used during dependency checking */
-- 
1.8.1.5


