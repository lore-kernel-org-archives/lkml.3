Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaKDTAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:00:08 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:40119 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaKDTAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:00:04 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 4 Nov 2014 14:00:01 -0500
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
Message-ID: <20141104190001.GE24112@csclub.uwaterloo.ca>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
 <1412014009-13315-12-git-send-email-bigeasy@linutronix.de>
 <20141104170233.GB24112@csclub.uwaterloo.ca>
 <5459079D.7080703@linutronix.de>
 <20141104172117.GC24112@csclub.uwaterloo.ca>
 <CABxcv=kT+M70Xoyf_z4eQQyM0Oo9S5Y0YeX2R6PbAqxK-JTLLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABxcv=kT+M70Xoyf_z4eQQyM0Oo9S5Y0YeX2R6PbAqxK-JTLLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 07:32:07PM +0100, Javier Martinez Canillas wrote:
> Hello,
> 
> On Tue, Nov 4, 2014 at 6:21 PM, Lennart Sorensen
> <lsorense@csclub.uwaterloo.ca> wrote:
> >> Mind sharing the manual with me? Mine does not mention DMA channels for
> >> UART7-10. If you are able to test 7+8 (and it works) could you please
> >> make patch which with for the remaining four devices?
> >
> > Well the file I have is called AM572x_ES1.1_NDA_TRM_vT.pdf, so I am not
> > sure who I am allowed to share that file with.  Might be simpler to just
> > ask TI for the latest version.
> >
> > How I hate NDAs.
> >
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

That's the right one.

Page 3622 has the dma channels for uart 7 through 10, but it still needs
the updated crossbar dma driver to work.

-- 
Len Sorensen
