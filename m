Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaJAHWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:22:30 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:40510 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJAHW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:22:29 -0400
X-Auth-Info: 4kbNabbEJIPRL1cw92d7qoIMRZxDLYA/d7uCrXNigH8=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: change git URL for mpc5xxx tree
Date: Wed,  1 Oct 2014 09:22:25 +0200
Message-Id: <1412148145-9608-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20141001090115.44146aa9@canb.auug.org.au>
References: <20141001090115.44146aa9@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The repository for mpc5xxx has been moved, update git URL to new location.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3705430..153229e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5478,7 +5478,7 @@ F:	drivers/macintosh/
 LINUX FOR POWERPC EMBEDDED MPC5XXX
 M:	Anatolij Gustschin <agust@denx.de>
 L:	linuxppc-dev@lists.ozlabs.org
-T:	git git://git.denx.de/linux-2.6-agust.git
+T:	git git://git.denx.de/linux-denx-agust.git
 S:	Maintained
 F:	arch/powerpc/platforms/512x/
 F:	arch/powerpc/platforms/52xx/
-- 
1.7.9.5

