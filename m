Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab3IBBpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:45:01 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:33675 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3IBBpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:45:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3kUhFEkN9Bjxi2kAMZRAsPKJXiYf=+SOkSuspZbYJEaE8jDA@mail.gmail.com>
References: <CAH3kUhE5BLt=373NYiA4-GDmz4v5g4ekxT=Bo6U35fn0uhwmOw@mail.gmail.com>
	<20130901185933.GA23936@electric-eye.fr.zoreil.com>
	<CAH3kUhENV0DD=oW94FVZ3bPvXXyHk5wN9ebmVHsoPoEO7+KA3w@mail.gmail.com>
	<CAH3kUhFEkN9Bjxi2kAMZRAsPKJXiYf=+SOkSuspZbYJEaE8jDA@mail.gmail.com>
Date: Sun, 1 Sep 2013 22:44:58 -0300
Message-ID: <CAH3kUhHkHxUVMPndG3bN9hUzheuxE5ji=CQ+93HyMOmhhD9v7Q@mail.gmail.com>
Subject: Re: network stopped with a kernel error
From: Roberto Spadim <roberto@spadim.com.br>
To: Francois Romieu <romieu@fr.zoreil.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the XID:
good card:

Sep  1 11:41:41 localhost kernel: [    4.332165] r8169 Gigabit
Ethernet driver 2.3LK-NAPI loaded
Sep  1 11:41:41 localhost kernel: [    4.332184] r8169 0000:01:00.0:
PCI INT A -> GSI 17 (level, low) -> IRQ 17
Sep  1 11:41:41 localhost kernel: [    4.332236] r8169 0000:01:00.0:
setting latency timer to 64
Sep  1 11:41:41 localhost kernel: [    4.332283] r8169 0000:01:00.0:
irq 40 for MSI/MSI-X
Sep  1 11:41:41 localhost kernel: [    4.332490] r8169 0000:01:00.0:
eth0: RTL8168d/8111d at 0xffffc900057a2000, f4:6d:04:cc:e9:13, XID
083000c0 IRQ 40



bad card:
Sep  1 11:41:41 localhost kernel: [    4.356510] r8169 Gigabit
Ethernet driver 2.3LK-NAPI loaded
Sep  1 11:41:41 localhost kernel: [    4.356524] r8169 0000:04:02.0:
PCI INT A -> GSI 17 (level, low) -> IRQ 17
Sep  1 11:41:41 localhost kernel: [    4.356561] r8169 0000:04:02.0:
(unregistered net_device): no PCI Express capability
Sep  1 11:41:41 localhost kernel: [    4.356569] r8169 0000:04:02.0:
(unregistered net_device): unknown MAC, using family default
Sep  1 11:41:41 localhost kernel: [    4.356815] r8169 0000:04:02.0:
eth2: RTL8169 at 0xffffc90005796000, ff:ff:ff:ff:ff:ff, XID 10400000
IRQ 17
