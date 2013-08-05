Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3HEWDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:03:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:52997 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab3HEWC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="381711017"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/16] x86, asmlinkage, apm: Make APM data structure used from assembler visible
Date: Mon,  5 Aug 2013 15:02:45 -0700
Message-Id: <1375740170-7446-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/apm_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 53a4e27..3ab0343 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -392,7 +392,7 @@ static struct cpuidle_device apm_cpuidle_device;
 /*
  * Local variables
  */
-static struct {
+__visible struct {
 	unsigned long	offset;
 	unsigned short	segment;
 } apm_bios_entry;
-- 
1.8.3.1

