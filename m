Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaHaKX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 06:23:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35127 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaHaKXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 06:23:54 -0400
Date: Sun, 31 Aug 2014 13:23:51 +0300
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ath9k: dmar: DRHD: handling fault status reg 3
Message-ID: <20140831132351.48c2a412@mdontu-l>
Organization: Home
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have this device:

03:02.0 Network controller: Qualcomm Atheros AR9227 Wireless Network Adapter (rev 01)
        Subsystem: Qualcomm Atheros Device 0300
        Flags: bus master, 66MHz, medium devsel, latency 168, IRQ 19
        Memory at f7c00000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] #80 [0000]
        Kernel driver in use: ath9k

which works great, except dmesg keeps being spammed with messages like
this one:

[ 2880.027256] dmar: DRHD: handling fault status reg 3
[ 2880.027260] dmar: DMAR:[DMA Read] Request device [03:00.0] fault addr ffffd000 DMAR:[fault reason 06] PTE Read access is not set

Is this a driver issue or a hardware one? Can I somehow silence it
without disabling the use of the IOMMU?

Thanks,

-- 
Mihai Donțu
