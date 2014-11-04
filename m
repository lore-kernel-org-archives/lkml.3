Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaKDSjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:39:39 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64265 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDSji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:39:38 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.101.112]
In-Reply-To: <20141104172117.GC24112@csclub.uwaterloo.ca>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
	<1412014009-13315-12-git-send-email-bigeasy@linutronix.de>
	<20141104170233.GB24112@csclub.uwaterloo.ca>
	<5459079D.7080703@linutronix.de>
	<20141104172117.GC24112@csclub.uwaterloo.ca>
Date: Tue, 4 Nov 2014 19:32:07 +0100
Message-ID: <CABxcv=kT+M70Xoyf_z4eQQyM0Oo9S5Y0YeX2R6PbAqxK-JTLLg@mail.gmail.com>
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 4, 2014 at 6:21 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>> Mind sharing the manual with me? Mine does not mention DMA channels for
>> UART7-10. If you are able to test 7+8 (and it works) could you please
>> make patch which with for the remaining four devices?
>
> Well the file I have is called AM572x_ES1.1_NDA_TRM_vT.pdf, so I am not
> sure who I am allowed to share that file with.  Might be simpler to just
> ask TI for the latest version.
>
> How I hate NDAs.
>

I saw today an announcement about a public AM572x Silicon Revision 1.1
TRM [0] that has just made available by TI. I'm not familiar with this
SoC so I don't know if that has the information you want but I thought
it was worth to mention in case it did.

Best regards,
Javier

[0]: http://www.ti.com/lit/ug/spruhz6/spruhz6.pdf
