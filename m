Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaATToB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:44:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaATTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:43:57 -0500
Date: Mon, 20 Jan 2014 19:43:50 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Bolle <pebolle@tiscali.nl>,
        Michael Ellerman <michael@ellerman.id.au>,
        Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/kconfig: Remove TSI108_BRIDGE duplicates
Message-ID: <20140120194344.GA5816@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MPC7448HPC2 and PPC_HOLLY config options contain TSI108_BRIDGE
duplicates since commit:

commit 3490cba56f7f8a78ef4c94814c3181f09ce1e2ef
Author: Jon Loeliger <jdl@jdl.com>
Date:   Wed Jan 23 12:42:50 2008 -0600

    [POWERPC] Add initial iomega StorCenter board port.

This patch cleans these duplicates.

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/embedded6xx/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/platforms/embedded6xx/Kconfig b/arch/powerpc/platforms/embedded6xx/Kconfig
index 302ba43..59bd9cd 100644
--- a/arch/powerpc/platforms/embedded6xx/Kconfig
+++ b/arch/powerpc/platforms/embedded6xx/Kconfig
@@ -34,7 +34,6 @@ config MPC7448HPC2
 	select TSI108_BRIDGE
 	select DEFAULT_UIMAGE
 	select PPC_UDBG_16550
-	select TSI108_BRIDGE
 	help
 	  Select MPC7448HPC2 if configuring for Freescale MPC7448HPC2 (Taiga)
 	  platform
@@ -44,7 +43,6 @@ config PPC_HOLLY
 	depends on EMBEDDED6xx
 	select TSI108_BRIDGE
 	select PPC_UDBG_16550
-	select TSI108_BRIDGE
 	help
 	  Select PPC_HOLLY if configuring for an IBM 750GX/CL Eval
 	  Board with TSI108/9 bridge (Hickory/Holly)
-- 
1.8.3.2

Cheers,
--
Luis
