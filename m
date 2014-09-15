Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbaIOWSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:18:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51125 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaIOWS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 041/187] x86, espfix: Fix broken header guard
Date: Mon, 15 Sep 2014 15:07:31 -0700
Message-Id: <1410818997-9432-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 20b68535cd27183ebd3651ff313afb2b97dac941 upstream.

Header guard is #ifndef, not #ifdef...

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/espfix.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/espfix.h b/arch/x86/include/asm/espfix.h
index 729051c..99efebb 100644
--- a/arch/x86/include/asm/espfix.h
+++ b/arch/x86/include/asm/espfix.h
@@ -1,4 +1,4 @@
-#ifdef _ASM_X86_ESPFIX_H
+#ifndef _ASM_X86_ESPFIX_H
 #define _ASM_X86_ESPFIX_H
 
 #ifdef CONFIG_X86_64
-- 
1.9.1

