Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3CKONf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:13:35 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:55500 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3CKONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:13:33 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:13:30 +0800
Message-ID: <CAPgLHd9ufsjGd9CvVf7y3jMXoN=rh7uc7jxiwZ9FHSeJ+XRzUQ@mail.gmail.com>
Subject: [PATCH -next] microblaze/PCI: remove duplicated include from pci-common.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: monstr@monstr.eu, grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/microblaze/pci/pci-common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 9ea521e..bdb8ea1 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -30,7 +30,6 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_pci.h>
-#include <linux/pci.h>
 #include <linux/export.h>
 
 #include <asm/processor.h>

