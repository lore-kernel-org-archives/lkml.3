Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab3HMOcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:32:16 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60924 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab3HMOcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <520A414A.1000102@linutronix.de>
References: <51F2BE6F.3010008@linutronix.de>
	<CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
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
Date: Tue, 13 Aug 2013 09:32:13 -0500
Message-ID: <CADYTM3Z9AwRz1z2k-Ve4xMoW5i2YRdxk2sJ3Aw-6tjR0oD1y7w@mail.gmail.com>
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

On Tue, Aug 13, 2013 at 9:23 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> Where is my memory going? So now I have a beagle bone in front of me
> and I see a micro USB port a standard A connector. My memory was
> different.
> The micro USB is the UART and standard is most likely the first musb
> instance. So this should run also in host mode and not in OTG mode.
> Hmmm. Let me double check this.
I don't know how dts instances both in mainline, but I would think if
you create two musb instances, and load a gadget driver for this micro
USB port, the USB host should enumerate it. The standard port should
be the 2nd instance which has its ID pin grounded and work in
host-only mode.

This is how they work in TI 3.2 kernel.

>
>
> Sebastian
