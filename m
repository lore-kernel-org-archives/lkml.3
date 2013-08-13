Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3HMNDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:03:33 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:52251 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3HMNDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <5209DCB9.8020705@linutronix.de>
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
Date: Tue, 13 Aug 2013 08:03:29 -0500
Message-ID: <CADYTM3a2M-X=eqz0LmSq4T9UF9khsTGB5TTYWWMRZWwkpRuRTQ@mail.gmail.com>
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

On Tue, Aug 13, 2013 at 2:14 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 08/09/2013 10:30 PM, Sergei Shtylyov wrote:
>> Hello.
>
> Hi Sergei,
>
>>> +    if (musb->port_mode == MUSB_PORT_MODE_HOST) {
>>> +        val = USBMODE_IDDIG_A;
>>> +        val |= USBMODE_ID_MUX_REG;
>>
>>    Why not do the above in one line and save on {} {}? It will look more
>> aesthetically pleasing IMHO.
>
> I'm going to redo this if it is agreed that we want to fix it that way.
I am going to so some tests today for this. I don't object to use the
mode register, but am wondering why we have to play with it for
host-only mode. The ID pin is grounded for host-only mode, which
should cause the same as setting mode register.

>
> Sebastian

-Bin.
