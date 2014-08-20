Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaHTMJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:09:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58895 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 022/104] x86, espfix: Fix broken header guard
Date: Wed, 20 Aug 2014 13:42:45 +0200
Message-Id: <134b7223097fea833afabe883d4d183364392eea.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 20b68535cd27183ebd3651ff313afb2b97dac941 upstream.

Header guard is #ifndef, not #ifdef...

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.4

