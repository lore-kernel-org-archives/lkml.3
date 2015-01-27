Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbbA0C73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:59:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:44069 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbbA0C71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:59:27 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
CC: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "peda@axentia.se" <peda@axentia.se>
Subject: RE: [PATCH v2 00/12] AT91 pm cleanup for 3.20
Thread-Topic: [PATCH v2 00/12] AT91 pm cleanup for 3.20
Thread-Index: AQHQOUuwFDQ6svrpJEa0lxoK5JMQdZzRo9gAgAGjnUA=
Date: Tue, 27 Jan 2015 02:58:41 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD35BFC@penmbx01>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
 <20150126095554.GA18807@gradator.net>
In-Reply-To: <20150126095554.GA18807@gradator.net>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0R2xdIE022303



> -----Original Message-----
> From: Sylvain Rochet [mailto:sylvain.rochet@finsecur.com]
> Sent: Monday, January 26, 2015 5:56 PM
> To: Yang, Wenyou
> Cc: Ferre, Nicolas; linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; alexandre.belloni@free-electrons.com;
> peda@axentia.se
> Subject: Re: [PATCH v2 00/12] AT91 pm cleanup for 3.20
> 
> Hello Wenyou,
> 
> On Mon, Jan 26, 2015 at 05:36:45PM +0800, Wenyou Yang wrote:
> > Hi Nicolas,
> >
> > This version is rebased on the branch: at91-3.20-cleanup of the repository
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git
> >
> > It is purpose to clean up the PM code, includes the patches from Peter Rosin
> and Sylvain Rochet.
> >
> > Since verifying the USB clock and USB PLL disabling before suspending
> > to memory, it aslo depends on the following patch serials from Sylvain:
> > 	[PATCHv6 0/5] USB: gadget: atmel_usba_udc: Driver improvements
> > 	[PATCHv7 0/6] USB: host: Atmel OHCI and EHCI drivers improvements
> >
> > Removes CONFIG_AT91_SLOW_CLOCK config item to simply the PM config,
> > The suspend to standby mode uses the same sram function as the suspend to
> memory mode.
> > Remove some unused code.
> >
> > Alexandr & Sylvain, Thank you very much for so many feedbacks.
> >
> > Changes in v2:
> >  - Rebase on the at91-3.20-cleanup branch
> >  - Recover the verify clock condition, only for suspend to memory.
> >  - Collect ACK from Alexandre
> >  - Add the macro for PM mode
> 
> Did you fix the slow_clock == NULL condition with the change suggested by
> Alexandre ?
Sorry, didn't. I will send v3 to fix it.

> 
> Sylvain

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
