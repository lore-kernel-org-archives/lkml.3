Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaDDGyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:54:05 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:43285 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaDDGyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:54:03 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Apr 2014 02:54:03 EDT
MIME-Version: 1.0
Date: Fri, 4 Apr 2014 12:17:51 +0530
Message-ID: <CAD6G_RTVPip-G34AxLRpFbs50WFFtWS6yth-r-E889h2B2Cd-w@mail.gmail.com>
Subject: Link up issue on ethernet/realtek/r8169.c
From: Jagan Teki <jagannadh.teki@gmail.com>
To: nic_swsd@realtek.com, romieu@fr.zoreil.com
Cc: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using TP-LINK PCIe NIC card on my PCIe Root Complex.

Probing looks fine by setting:
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
PCI: enabling device 0000:00:00.0 (0140 -> 0143)
PCI: enabling device 0000:01:00.0 (0140 -> 0143)
r8169 0000:01:00.0 eth0: RTL8168e/8111e at 0xf006a000,
c0:4a:00:07:18:d4, XID 0c200000 IRQ 89
r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx
checksumming: ko]

But I have an issue while in link is up

$ ifconfig 192.168.1.10 up
r8169 0000:01:00.0: Direct firmware load failed with error -2
r8169 0000:01:00.0: Falling back to user helper
r8169 0000:01:00.0 eth0: unable to load firmware patch
rtl_nic/rtl8168e-2.fw (-2)
r8169 0000:01:00.0 eth0: link down

Looks like firmware loading is failed in open call, Can any one
suggest how to debug further.

thanks!
-- 
Jagan.
