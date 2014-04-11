Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaDKWbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:31:07 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:40477 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755711AbaDKWbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:31:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkOAH1sSFNbsn1W/2dsb2JhbABZgwaDTrkwhzECAoEdF3SCLQI3HCMYcREkE4gAActwjmyEPwEDjl6HKoJXAYpjh1+DMzs
Date: Sat, 12 Apr 2014 00:32:57 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/1] arch/arm/mach-ks8695/board-og.c: __initdata fix
Message-Id: <20140412003257.d66b1b91c74b44ca8f2e5c6d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place __initdata before equal signs.

Cc: linux-arm-kernel@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/mach-ks8695/board-og.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ks8695/board-og.c b/arch/arm/mach-ks8695/board-og.c
index f265816..2627d82 100644
--- a/arch/arm/mach-ks8695/board-og.c
+++ b/arch/arm/mach-ks8695/board-og.c
@@ -30,7 +30,7 @@ static int og_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return KS8695_IRQ_EXTERN0;
 }
 
-static struct ks8695_pci_cfg __initdata og_pci = {
+static struct ks8695_pci_cfg og_pci __initdata = {
 	.mode		= KS8695_MODE_PCI,
 	.map_irq	= og_pci_map_irq,
 };
@@ -80,7 +80,7 @@ static void __init og_pci_bus_reset(void)
 #define	S8250_VIRT	0xf4000000
 #define	S8250_SIZE	0x00100000
 
-static struct __initdata map_desc og_io_desc[] = {
+static struct map_desc og_io_desc[] __initdata = {
 	{
 		.virtual	= S8250_VIRT,
 		.pfn		= __phys_to_pfn(S8250_PHYS),
-- 
1.8.4.5

