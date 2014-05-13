Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaEMKXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:23:02 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933501AbaEMKL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Vineet Gupta <vgupta@synopsys.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 140/182] ARC: Remove ARC_HAS_COH_RTSC
Date: Tue, 13 May 2014 11:28:12 +0200
Message-Id: <5123768e27f13df3394e498895c44f444421718f.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d345ea2892ae7a2b70f84cf881c20731e43e4993 upstream.

The symbol is an orphan, get rid of it.

Fixes: 7d0857a54aed ("ARC: [SMP] Disallow RTSC")
Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arc/plat-arcfpga/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 295cefeb25d3..33058aa40e77 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -33,7 +33,6 @@ config ISS_SMP_EXTN
 	bool "ARC SMP Extensions (ISS Models only)"
 	default n
 	depends on SMP
-	select ARC_HAS_COH_RTSC
 	help
 	  SMP Extensions to ARC700, in a "simulation only" Model, supported in
 	  ARC ISS (Instruction Set Simulator).
-- 
1.9.3

