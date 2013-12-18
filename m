Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3LRTlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:41:47 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49434 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LRTlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:41:46 -0500
Message-ID: <52b1fa78.47cc0e0a.67ff.ffffcb29@mx.google.com>
From: Silvan Jegen <s.jegen@gmail.com>
Date: Wed, 18 Dec 2013 20:16:31 +0100
Subject: [PATCH] Documentation: Fix trivial spelling mistake in efi-stub.txt
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Silvan Jegen <s.jegen@gmail.com>
---
 Documentation/efi-stub.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index 44e6bb6..c628788 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -20,7 +20,7 @@ The EFI boot stub is enabled with the CONFIG_EFI_STUB kernel option.
 **** How to install bzImage.efi
 
 The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
-System Partiion (ESP) and renamed with the extension ".efi". Without
+System Partition (ESP) and renamed with the extension ".efi". Without
 the extension the EFI firmware loader will refuse to execute it. It's
 not possible to execute bzImage.efi from the usual Linux file systems
 because EFI firmware doesn't have support for them.
-- 
1.8.5.1

