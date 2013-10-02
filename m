Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3JBFY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:24:29 -0400
Received: from mout.web.de ([212.227.15.4]:49750 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab3JBFYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:24:24 -0400
From: Martin Walch <walch.martin@web.de>
Cc: Michal Marek <mmarek@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        Alan Cox <alan@linux.intel.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] kconfig: add short explanation to SYMBOL_WRITE
Date: Wed, 02 Oct 2013 07:24:20 +0200
Message-ID: <4542076.yVG8YKgu5r@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K0:4uiXwAE3+iEXQTwdnsDOwC+6e1hKqLBsS/uIhkgCUPDgNhShgoB
 KxyG2e9dIQDI/AFzpIt1lYUgXrhGOpITZpFhMsrq/oAKd+c6IxqJ86X8D/3H7hkwvanYPqZ
 WMD4aZ5Hf7bjzz3zKeVveqBVyh8j4iTS+vWJ63DxmpiLj2L+QjEJxaOLCtAjBSuQwB7Spki
 S8bnTqWseRwMfbkv4l2cA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Wed, 2 Oct 2013 06:54:27 +0200
Subject: [PATCH 1/4] kconfig: add short explanation to SYMBOL_WRITE

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


