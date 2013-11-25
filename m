Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3KYEaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 23:30:10 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51952 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3KYEaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 23:30:06 -0500
From: dt.tangr@gmail.com
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Tang <dt.tangr@gmail.com>,
        linux@arm.linux.org.uk
Subject: [PATCH 2/2] arm: nspire: fix nspire_restart to take enum reboot_mode instead of a char so the correct function pointer is passed to DT_MACHINE_START
Date: Mon, 25 Nov 2013 15:29:24 +1100
Message-Id: <1385353764-88784-2-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1385353764-88784-1-git-send-email-dt.tangr@gmail.com>
References: <1385353764-88784-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/mach-nspire/nspire.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-nspire/nspire.c b/arch/arm/mach-nspire/nspire.c
index 4b2ed2e..3d24ebf 100644
--- a/arch/arm/mach-nspire/nspire.c
+++ b/arch/arm/mach-nspire/nspire.c
@@ -63,7 +63,7 @@ static void __init nspire_init(void)
 			nspire_auxdata, NULL);
 }

-static void nspire_restart(char mode, const char *cmd)
+static void nspire_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *base = ioremap(NSPIRE_MISC_PHYS_BASE, SZ_4K);
 	if (!base)
--
1.8.1.3

