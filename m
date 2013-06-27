Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3F0Bux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:50:53 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14581 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3F0Buv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:50:51 -0400
X-Spam-Score: -100.8
Message-ID: <51CB9A41.20903@asianux.com>
Date: Thu, 27 Jun 2013 09:49:53 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hirokazu Takata <takata@linux-m32r.org>
CC: "dhowells@redhat.com" <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: m32r: include: asm: add kvm_para.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kvm_para.h for pass compiling.

The related error (with allmodconfig):

  In file included from include/linux/kvm_para.h:4:0,
                   from kernel/watchdog.c:29:
  include/uapi/linux/kvm_para.h:26:26: fatal error: asm/kvm_para.h: No such file or directory

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/m32r/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index bebdc36..1943db2 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,5 +1,6 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += kvm_para.h
 generic-y += module.h
 generic-y += trace_clock.h
-- 
1.7.7.6
