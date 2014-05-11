Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbaEKT6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:58:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbaEKTVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, Paul Bolle <pebolle@tiscali.nl>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 3.14 24/83] ARC: Remove ARC_HAS_COH_RTSC
Date: Sun, 11 May 2014 21:19:25 +0200
Message-Id: <20140511191910.353580630@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit d345ea2892ae7a2b70f84cf881c20731e43e4993 upstream.

The symbol is an orphan, get rid of it.

Fixes: 7d0857a54aed ("ARC: [SMP] Disallow RTSC")
Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/plat-arcfpga/Kconfig |    1 -
 1 file changed, 1 deletion(-)

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


