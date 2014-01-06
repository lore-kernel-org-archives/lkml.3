Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbaAFXBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:01:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbaAFWmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 125/129] arm64: Remove unused cpu_name ascii in arch/arm64/mm/proc.S
Date: Mon,  6 Jan 2014 14:39:14 -0800
Message-Id: <20140106223903.173133510@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit f3a1d7d53dccf51959aec16b574617cc6bfeca09 upstream.

This string has been moved to arch/arm64/kernel/cputable.c.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/proc.S |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -95,10 +95,6 @@ ENTRY(cpu_do_switch_mm)
 	ret
 ENDPROC(cpu_do_switch_mm)
 
-cpu_name:
-	.ascii	"AArch64 Processor"
-	.align
-
 	.section ".text.init", #alloc, #execinstr
 
 /*


