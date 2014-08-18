Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaHRJos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:44:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaHRJgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 109/137] x86, espfix: Fix broken header guard
Date: Mon, 18 Aug 2014 10:32:50 +0100
Message-Id: <1408354398-10226-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 20b68535cd27183ebd3651ff313afb2b97dac941 upstream.

Header guard is #ifndef, not #ifdef...

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/asm/espfix.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/espfix.h b/arch/x86/include/asm/espfix.h
index 729051c82b02..99efebb2f69d 100644
--- a/arch/x86/include/asm/espfix.h
+++ b/arch/x86/include/asm/espfix.h
@@ -1,4 +1,4 @@
-#ifdef _ASM_X86_ESPFIX_H
+#ifndef _ASM_X86_ESPFIX_H
 #define _ASM_X86_ESPFIX_H
 
 #ifdef CONFIG_X86_64
-- 
1.9.1

