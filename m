Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3HMHOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:14:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:47725 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3HMHOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:14:06 -0400
Message-ID: <5209DCB9.8020705@linutronix.de>
Date: Tue, 13 Aug 2013 09:14:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Bin Liu <binmlist@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, george.cherian@ti.com
Subject: Re: [PATCH] usb: musb: am335x: Do not remove the session bin HOST-only
 mode
References: <51F2BE6F.3010008@linutronix.de> <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com> <51F2D427.7050106@linutronix.de> <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com> <51F2DD90.2030405@linutronix.de> <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com> <20130729165329.GA5773@linutronix.de> <CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com> <51F6ABA2.7060102@linutronix.de> <CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com> <20130809160339.GA14829@linutronix.de> <5205516D.1030707@cogentembedded.com>
In-Reply-To: <5205516D.1030707@cogentembedded.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 10:30 PM, Sergei Shtylyov wrote:
> Hello.

Hi Sergei,

>> +    if (musb->port_mode == MUSB_PORT_MODE_HOST) {
>> +        val = USBMODE_IDDIG_A;
>> +        val |= USBMODE_ID_MUX_REG;
> 
>    Why not do the above in one line and save on {} {}? It will look more
> aesthetically pleasing IMHO.

I'm going to redo this if it is agreed that we want to fix it that way.

Sebastian
