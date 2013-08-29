Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3H2EsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:48:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42996 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3H2EsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:48:09 -0400
X-Spam-Score: -101.0
Message-ID: <521ED249.6080001@asianux.com>
Date: Thu, 29 Aug 2013 12:47:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>, ak@linux.intel.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] h8300/kernel/timer/timer8.c: add the missing semicolon
References: <521EC55A.9030905@asianux.com>
In-Reply-To: <521EC55A.9030905@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing semicolon to fix the typo issue.

The related error: (defconfig for H8S):

  arch/h8300/kernel/timer/timer8.c: In function 'h8300_timer_setup':
  arch/h8300/kernel/timer/timer8.c:98:2: error: expected ';' before 'ctrl_outw'


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/kernel/timer/timer8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 505f341..8aac2a7 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -91,7 +91,7 @@ void __init h8300_timer_setup(void)
 
 #if defined(CONFIG_CPU_H8S)
 	/* Timer module enable */
-	ctrl_bclr(0, MSTPCRL)
+	ctrl_bclr(0, MSTPCRL);
 #endif
 
 	/* initialize timer */
-- 
1.7.7.6
