Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3FEPyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:54:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab3FEPyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:14 -0400
Message-ID: <51AF5F1F.6010903@suse.com>
Date: Wed, 05 Jun 2013 11:54:07 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paul Mackerras <paulus@au.ibm.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc: add missing include to book3s_xics.c
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following build failure:
arch/powerpc/kvm/book3s_xics.c:812: error: implicit declaration of function 'get_tb'

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 arch/powerpc/kvm/book3s_xics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -19,6 +19,7 @@
 #include <asm/hvcall.h>
 #include <asm/xics.h>
 #include <asm/debug.h>
+#include <asm/time.h>
 
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>


-- 
Jeff Mahoney
SUSE Labs
