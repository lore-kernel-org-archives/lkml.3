Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354Ab3HNSn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:43:26 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34824 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033Ab3HNSnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <520BC9A6.608@linutronix.de>
References: <51F2BE6F.3010008@linutronix.de>
	<51F2D427.7050106@linutronix.de>
	<CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
	<51F2DD90.2030405@linutronix.de>
	<CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com>
	<20130729165329.GA5773@linutronix.de>
	<CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com>
	<51F6ABA2.7060102@linutronix.de>
	<CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com>
	<20130809160339.GA14829@linutronix.de>
	<5205516D.1030707@cogentembedded.com>
	<5209DCB9.8020705@linutronix.de>
	<CADYTM3a2M-X=eqz0LmSq4T9UF9khsTGB5TTYWWMRZWwkpRuRTQ@mail.gmail.com>
	<520A3206.5080505@linutronix.de>
	<CADYTM3YU=xt-YDaoOqothjAv_rdnzRmop10Rf7PSA7POaE5DBQ@mail.gmail.com>
	<520A3847.4090506@linutronix.de>
	<CADYTM3YDmBw2Due5boftM_a+U2EcVaw8d9sFo8167Q0v1KSRgQ@mail.gmail.com>
	<520A414A.1000102@linutronix.de>
	<CADYTM3Z9AwRz1z2k-Ve4xMoW5i2YRdxk2sJ3Aw-6tjR0oD1y7w@mail.gmail.com>
	<520BC9A6.608@linutronix.de>
Date: Wed, 14 Aug 2013 13:43:20 -0500
Message-ID: <CADYTM3YQjmBmuzfQU3gVtD_1qrE3PG1LjbHn35CsU94ord7D5Q@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: am335x: Do not remove the session bin
 HOST-only mode
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Wed, Aug 14, 2013 at 1:17 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> So I tried to boot my beagle bone board to figure out if they use the
> first or the second port in host mode (but it doesn't boot). The tiny
> micro USB plug is 100% for UART and not wired up to MUSB.

I have not run the mainline kernel on beagle bone yet, so I cannot
comment how it works, and it does not surprise if something is broken
since this is what you are trying to fix ;)

But I just booted my beagle bone with the out-of-box SD card which has
Angstrom 3.2.34 kernel. The USB0 port is in device mode with
g_mass_storage.ko loaded, and USB1 is in host-only mode.

> Any comments on that patch? I would remove the ID pin changes and
> repost if you don't mind.

That is okay to me, as long as both USB ports on the GP evm work.

-Bin.
