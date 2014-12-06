Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaLFR60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:58:26 -0500
Received: from 1wt.eu ([62.212.114.60]:40727 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaLFRzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:55:04 -0500
Message-Id: <20141206174148.773173830@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:41:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 08/25] x86, espfix: Fix broken header guard
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 20b68535cd27183ebd3651ff313afb2b97dac941 upstream.

Header guard is #ifndef, not #ifdef...

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
(cherry picked from 3.2 commit 7d4a9eabfe6c7fed70941aceb3b20bf393652bcb)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/espfix.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/espfix.h b/arch/x86/include/asm/espfix.h
index e2fb446..f017535 100644
--- a/arch/x86/include/asm/espfix.h
+++ b/arch/x86/include/asm/espfix.h
@@ -1,4 +1,4 @@
-#ifdef _ASM_X86_ESPFIX_H
+#ifndef _ASM_X86_ESPFIX_H
 #define _ASM_X86_ESPFIX_H
 
 #ifdef CONFIG_X86_64
-- 
1.7.12.2.21.g234cd45.dirty



