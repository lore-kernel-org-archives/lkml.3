Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbaEKTx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:53:56 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:37445 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaEKTxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <ea072022-5c98-4b69-b0e1-6beff47fa5e1@googlegroups.com>
References: <1399173287.6962.3.camel@phoenix>
	<CABjd4Yw=U4S0H4bqhrnuHbt3hYVke7GbOeGgPpVJfGhLJ=iWyQ@mail.gmail.com>
	<ea072022-5c98-4b69-b0e1-6beff47fa5e1@googlegroups.com>
Date: Sun, 11 May 2014 23:53:52 +0400
Message-ID: <CABjd4YyPsNP3YT8Y7BoS-SMe8=dkZDs=dj7vcvL5soLNVZ_3aQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] irqchip: vt8500: Properly mask the interrupt in irq_mask()
From: Alexey Charkov <alchark@gmail.com>
To: "VT8500/WM8505 Linux Kernel" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Prisk <linux@prisktech.co.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-11 23:29 GMT+04:00 lautriv <lautriv.himself@gmail.com>:
> Alexey, i wonder how you can tell "all works fine" since 8850 is still
> vomiting a bunch when it comes to I2C or GPIO. Maybe i missed some changes
> there ?

I've never noticed anything like that on my machine... Note though
that I don't use I2C actively (or at all), and I'm currently on
mainline 3.15-rc2 with just Rhine patches on top (upstream for 3.16)
and some changes in dts to suit my netbook. GPIO works fine for me -
I've only applied another one-liner to make 'echo high > direction'
work (also upstream now).

I've got a fully functioning Fedora 20 on my WM8850 (except sound and
other known-missing parts, of course). It's updating KDE4 as I type
:-)

Best,
Alexey
