Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3I1Rz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab3I1Rz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:55:57 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH] cris/PCI: Remove pci_mem_start
To: starvik@axis.com, jesper.nilsson@axis.com, bhelgaas@google.com
Cc: linux-cris-kernel@axis.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 28 Sep 2013 11:55:49 -0600
Message-ID: <20130928175548.8612.84198.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused 'pci_mem_start' variable.

CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/cris/include/asm/pci.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/cris/include/asm/pci.h b/arch/cris/include/asm/pci.h
index 146da90..f666734 100644
--- a/arch/cris/include/asm/pci.h
+++ b/arch/cris/include/asm/pci.h
@@ -11,7 +11,6 @@
 
 #define pcibios_assign_all_busses(void) 1
 
-extern unsigned long pci_mem_start;
 #define PCIBIOS_MIN_IO		0x1000
 #define PCIBIOS_MIN_MEM		0x10000000
 

