Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3FYCG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:06:26 -0400
Received: from intranet.asianux.com ([58.214.24.6]:26546 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3FYCGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:06:24 -0400
X-Spam-Score: -100.8
Message-ID: <51C8FAEC.10101@asianux.com>
Date: Tue, 25 Jun 2013 10:05:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: msalter@redhat.com, a-jacquiot@ti.com
CC: jkc@redhat.com, linux-c6x-dev@linux-c6x.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: c6x: platforms: include "asm/special_insns.h" to pass
 compiling
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include "asm/special_insns.h" to pass compiling.

The related error (with allmodconfig):
  arch/c6x/platforms/plldata.c: In function ‘c6472_setup_clocks’:
  arch/c6x/platforms/plldata.c:279:2: error: implicit declaration of function ‘get_coreid’ [-Werror=implicit-function-declaration]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/c6x/platforms/plldata.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/c6x/platforms/plldata.c b/arch/c6x/platforms/plldata.c
index 755359e..ddd1441 100644
--- a/arch/c6x/platforms/plldata.c
+++ b/arch/c6x/platforms/plldata.c
@@ -20,6 +20,7 @@
 #include <asm/clock.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
+#include <asm/special_insns.h>
 
 /*
  * Common SoC clock support.
-- 
1.7.7.6
