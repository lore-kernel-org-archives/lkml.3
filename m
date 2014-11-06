Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaKFSgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:36:50 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60727 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaKFSgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:36:49 -0500
Date: Thu, 6 Nov 2014 22:36:39 +0400
From: Dmitry Voytik <voytikd@gmail.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx: refactor mxc_iomux_mode()
Message-ID: <20141106183639.GA17308@ubuntuvm>
References: <1413902151-20255-1-git-send-email-voytikd@gmail.com>
 <20141027142054.GB14033@voytthpd>
 <54dc2a9edf554125b2158a1f9edd8adb@BN1PR0301MB0772.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54dc2a9edf554125b2158a1f9edd8adb@BN1PR0301MB0772.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Nov 04, 2014 at 12:21:55PM +0000, Peter Chen wrote:

> > > -int mxc_iomux_mode(unsigned int pin_mode)
> > > +void mxc_iomux_mode(unsigned int pin_mode)
> > >  {
> > > -	u32 field, l, mode, ret = 0;
> > > +	u32 field;
> > > +	u32 l;
> > > +	u32 mode;
> > >  	void __iomem *reg;
> > >
> 
> Why you use three lines to define it, it makes the function longer.

You're right but there is a recommendation in coding style to declare
variables on separate lines (see Documentation/CodingStyle,
line 469), which improves readability, imho. By the way I saw many
times, that maintainers asked to declare variables separately.

> Besides, Shawn's email changes to : <shawn.guo@linaro.org>

Oops, didn't see that. Thanks!

WBR.
