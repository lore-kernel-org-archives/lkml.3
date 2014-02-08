Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaBHHxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:53:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:16133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaBHHw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="451781485"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/14] initconst, x86: Fix initconst mistake in ts5500 code
Date: Sat,  8 Feb 2014 08:52:10 +0100
Message-Id: <1391845930-28580-14-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

const data must be initconst.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/platform/ts5500/ts5500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 39febb2..9471b94 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -88,7 +88,7 @@ struct ts5500_sbc {
 static const struct {
 	const char * const string;
 	const ssize_t offset;
-} ts5500_signatures[] __initdata = {
+} ts5500_signatures[] __initconst = {
 	{ "TS-5x00 AMD Elan", 0xb14 },
 };
 
-- 
1.8.5.2

