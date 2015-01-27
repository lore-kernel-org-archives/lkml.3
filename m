Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbbA0KLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:11:22 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:63105 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754030AbbA0KLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:11:18 -0500
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
Subject: RE: [PATCH v3 08/13] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
Thread-Topic: [PATCH v3 08/13] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
Thread-Index: AQHQOfZaTwRcvdqwnUaoeGtTTY8qhZzTOFYAgACGloA=
Date: Tue, 27 Jan 2015 10:11:00 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD35F4B@penmbx01>
References: <1422337810-3257-1-git-send-email-wenyou.yang@atmel.com>
 <1422338300-5984-1-git-send-email-wenyou.yang@atmel.com>
 <20150127100824.GC32121@gradator.net>
In-Reply-To: <20150127100824.GC32121@gradator.net>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0RABPrR024166

Hi Sylvain,

Thanks a lot.

> -----Original Message-----
> From: Sylvain Rochet [mailto:sylvain.rochet@finsecur.com]
> Sent: Tuesday, January 27, 2015 6:08 PM
> To: Yang, Wenyou
> Cc: Ferre, Nicolas; linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; alexandre.belloni@free-electrons.com;
> peda@axentia.se; sergei.shtylyov@cogentembedded.com; linux@maxim.org.za
> Subject: Re: [PATCH v3 08/13] pm: at91: the standby mode uses the same sram
> function as the suspend to memory mode
> 
> Hello Wenyou,
> 
> On Tue, Jan 27, 2015 at 01:58:20PM +0800, Wenyou Yang wrote:
> >
> > diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c index
> > 0377c0d..d967c31 100644
> > --- a/arch/arm/mach-at91/pm.c
> > +++ b/arch/arm/mach-at91/pm.c
> > @@ -71,7 +71,7 @@ static int at91_pm_begin(suspend_state_t state)
> >   * Verify that all the clocks are correct before entering
> >   * slow-clock mode.
> >   */
> > -static int at91_pm_verify_clocks(void)
> > +static int at91_pm_verify_clocks(suspend_state_t state)
> >  {
> >  	unsigned long scsr;
> >  	int i;
> > @@ (...)
> 
> Unused state argument, it was added in v2, this is just a trace of a reverted v2
> change not fully cleaned.

Yes, not clear.
> 
> 
> > +		if (!at91_pm_verify_clocks(state))
> > +			goto error;
> 
> Ditto.
> 
> 
> Sylvain

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
