Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaKDSs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:48:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40636 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaKDSs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:48:57 -0500
Message-ID: <54591F74.9090103@ti.com>
Date: Tue, 4 Nov 2014 12:48:20 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-serial@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>	<1412014009-13315-12-git-send-email-bigeasy@linutronix.de>	<20141104170233.GB24112@csclub.uwaterloo.ca>	<5459079D.7080703@linutronix.de>	<20141104172117.GC24112@csclub.uwaterloo.ca> <CABxcv=kT+M70Xoyf_z4eQQyM0Oo9S5Y0YeX2R6PbAqxK-JTLLg@mail.gmail.com>
In-Reply-To: <CABxcv=kT+M70Xoyf_z4eQQyM0Oo9S5Y0YeX2R6PbAqxK-JTLLg@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 12:32 PM, Javier Martinez Canillas wrote:
> Hello,
> 
> On Tue, Nov 4, 2014 at 6:21 PM, Lennart Sorensen
> <lsorense@csclub.uwaterloo.ca> wrote:
>>> Mind sharing the manual with me? Mine does not mention DMA channels for
>>> UART7-10. If you are able to test 7+8 (and it works) could you please
>>> make patch which with for the remaining four devices?
>>
>> Well the file I have is called AM572x_ES1.1_NDA_TRM_vT.pdf, so I am not
>> sure who I am allowed to share that file with.  Might be simpler to just
>> ask TI for the latest version.
>>
>> How I hate NDAs.
>>
> 
> I saw today an announcement about a public AM572x Silicon Revision 1.1
> TRM [0] that has just made available by TI. I'm not familiar with this
> SoC so I don't know if that has the information you want but I thought
> it was worth to mention in case it did.
> 
> Best regards,
> Javier
> 
> [0]: http://www.ti.com/lit/ug/spruhz6/spruhz6.pdf

Same chip.


-- 
Regards,
Nishanth Menon
