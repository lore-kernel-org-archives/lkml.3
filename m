Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3LLH7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:59:42 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34191 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3LLH7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:59:23 -0500
Message-ID: <52A96D01.1050503@gmail.com>
Date: Thu, 12 Dec 2013 09:00:01 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: 3.12: ethernet controller missing after resuming from suspend to
 RAM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm encountering an issue after resuming my system from suspend to RAM:
my ethernet controller is missing, it seems that the kernel doesn't see
it anymore. It's missing from /sys/class/net.

Before suspending, this is what lspci gives.

03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 0a)
        Subsystem: CLEVO/KAPOK Computer Device 0540
        Flags: bus master, fast devsel, latency 0, IRQ 46
        I/O ports at e000 [size=256]
        Memory at f0a04000 (64-bit, prefetchable) [size=4K]
        Memory at f0a00000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
        Capabilities: [d0] Vital Product Data
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [160] Device Serial Number 02-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
        Kernel modules: r8169

I can't see anything obvious in dmesg.

Could anybody help me to fix this ?

Thanks.
