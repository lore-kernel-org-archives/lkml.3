Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbbAFL1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:27:41 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53709 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbbAFL1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:27:11 -0500
From: esben.haabendal@gmail.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Esben Haabendal <eha@deif.com>
Subject: [PATCH 2/3] powerpc: Add machine_check cpu function for e300c3 cpus
Date: Tue,  6 Jan 2015 12:26:59 +0100
Message-Id: <1420543620-20658-2-git-send-email-esben.haabendal@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420543620-20658-1-git-send-email-esben.haabendal@gmail.com>
References: <1420543620-20658-1-git-send-email-esben.haabendal@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Esben Haabendal <eha@deif.com>

Signed-off-by: Esben Haabendal <eha@deif.com>
---
 arch/powerpc/kernel/cputable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 8084059..f337666 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -1133,6 +1133,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.icache_bsize		= 32,
 		.dcache_bsize		= 32,
 		.cpu_setup		= __setup_cpu_603,
+		.machine_check		= machine_check_generic,
 		.num_pmcs		= 4,
 		.oprofile_cpu_type	= "ppc/e300",
 		.oprofile_type		= PPC_OPROFILE_FSL_EMB,
-- 
2.1.4

