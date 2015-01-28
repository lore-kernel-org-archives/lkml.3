Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbbA1WZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:25:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:64354 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbbA1ULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:11:39 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
CC: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "peda@axentia.se" <peda@axentia.se>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>,
        "linux@maxim.org.za" <linux@maxim.org.za>
Subject: RE: [PATCH v4 00/13] AT91 pm cleanup for 3.20
Thread-Topic: [PATCH v4 00/13] AT91 pm cleanup for 3.20
Thread-Index: AQHQOptf4BMn4ugjt0GBFS6y1iLbf5zUtgyAgAAB6ACAAIbGkA==
Date: Wed, 28 Jan 2015 09:12:07 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD377D3@penmbx01>
References: <1422409172-24178-1-git-send-email-wenyou.yang@atmel.com>
 <20150128085913.GA7742@gradator.net> <20150128090602.GA19088@gradator.net>
In-Reply-To: <20150128090602.GA19088@gradator.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0SMPFTn008045

Hi Sylvain,

> -----Original Message-----
> From: Sylvain Rochet [mailto:sylvain.rochet@finsecur.com]
> Sent: Wednesday, January 28, 2015 5:06 PM
> To: Yang, Wenyou
> Cc: Ferre, Nicolas; linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; alexandre.belloni@free-electrons.com;
> peda@axentia.se; sergei.shtylyov@cogentembedded.com; linux@maxim.org.za
> Subject: Re: [PATCH v4 00/13] AT91 pm cleanup for 3.20
> 
> Hello Wenyou,
> 
> On Wed, Jan 28, 2015 at 09:59:13AM +0100, Sylvain Rochet wrote:
> > Hello Wenyou,
> >
> > On Wed, Jan 28, 2015 at 09:39:32AM +0800, Wenyou Yang wrote:
> > > Hi Nicolas,
> > >
> > > This version is rebased on the branch: at91-3.20-cleanup of the repository
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git
> > >
> > > It is purpose to clean up the PM code, includes the patches from Peter Rosin
> and Sylvain Rochet.
> > >
> > > Since verifying the USB clock and USB PLL disabling before
> > > suspending to memory, it aslo depends on the following patch serials from
> Sylvain:
> > > 	[PATCHv6 0/5] USB: gadget: atmel_usba_udc: Driver improvements
> > > 	[PATCHv7 0/6] USB: host: Atmel OHCI and EHCI drivers improvements
> > >
> > > Removes CONFIG_AT91_SLOW_CLOCK config item to simply the PM config,
> > > The suspend to standby mode uses the same sram function as the suspend to
> memory mode.
> > > Remove some unused code.
> > >
> > > Alexandr & Sylvain, Thank you very much for so many feedbacks.
> > >
> > > Changes in v2:
> > >  - Rebase on the at91-3.20-cleanup branch
> > >  - Recover the verify clock condition, only for suspend to memory.
> > >  - Collect ACK from Alexandre
> > >  - Add the macro for PM mode
> > >
> > > Changes in v3:
> > >  - Clear unused state argument in at91_pm_verify_clocks()
> > >  - Remove pr_info("AT91:... slow_clock ? ..") in patch 07/13.
> >
> > Changes in v4: ? :-)

Yes, I am not careful.

Can I resend?

> 
> Actually, I guess it is:
> 
> Changes in v2:
>  - Rebase on the at91-3.20-cleanup branch
>  - Recover the verify clock condition, only for suspend to memory.
>  - Collect ACK from Alexandre
>  - Add the macro for PM mode
> 
> Changes in v3
>  - Sylvain splits the patch in two
>  - Add handling if no sram allocated for PM
>  - Retain the STANDBY and SUSPEND_MEM select in at91_pm_enter.
> 
> Changes in v4:
>  - Clear unused state argument in at91_pm_verify_clocks()
>  - Remove pr_info("AT91:... slow_clock ? ..") in patch 07/13.
> 
> 
> (I prefer the reverse order, but, details)
> 
> Sylvain

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
