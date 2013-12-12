Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab3LLRpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:45:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61173 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751018Ab3LLRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:45:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Thu, 12 Dec 2013 18:58:53 +0100
Message-ID: <55495319.9jUzi5g5UA@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52A9F5A7.8030305@gmail.com>
References: <52A96D01.1050503@gmail.com> <4421787.xvooIB0ROV@vostro.rjw.lan> <52A9F5A7.8030305@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 12, 2013 06:43:03 PM Francis Moreau wrote:
> Hi Rafael,
> 
> On 12/12/2013 03:57 PM, Rafael J. Wysocki wrote:
> > On Thursday, December 12, 2013 09:00:01 AM Francis Moreau wrote:
> >> Hello,
> >>
> >> I'm encountering an issue after resuming my system from suspend to RAM:
> >> my ethernet controller is missing, it seems that the kernel doesn't see
> >> it anymore. It's missing from /sys/class/net.
> >>
> >> Before suspending, this is what lspci gives.
> >>
> >> 03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd.
> >> RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 0a)
> >>         Subsystem: CLEVO/KAPOK Computer Device 0540
> >>         Flags: bus master, fast devsel, latency 0, IRQ 46
> >>         I/O ports at e000 [size=256]
> >>         Memory at f0a04000 (64-bit, prefetchable) [size=4K]
> >>         Memory at f0a00000 (64-bit, prefetchable) [size=16K]
> >>         Capabilities: [40] Power Management version 3
> >>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
> >>         Capabilities: [70] Express Endpoint, MSI 01
> >>         Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
> >>         Capabilities: [d0] Vital Product Data
> >>         Capabilities: [100] Advanced Error Reporting
> >>         Capabilities: [160] Device Serial Number 02-00-00-00-68-4c-e0-00
> >>         Kernel driver in use: r8169
> >>         Kernel modules: r8169
> >>
> >> I can't see anything obvious in dmesg.
> > 
> > Please send a dmesg output including the first suspend-resume cycle
> > after a fresh boot (the one when you lose the NIC).
> 
> Here it is.
> 
> Actually I can see this now:
> 
> [   42.400974] r8169 0000:03:00.2: System wakeup disabled by ACPI

This should be harmless.

Please run lspci -vv before and after suspend and send both results.

Thanks,
Rafael

