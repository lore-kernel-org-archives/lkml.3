Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaACXj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:39:59 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54177 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaACXj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:39:56 -0500
Date: Fri, 3 Jan 2014 15:08:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "bpringlemeir@nbsps.com" <bpringlemeir@nbsps.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: Re: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
Message-ID: <20140103230826.GB13489@core.coreip.homeip.net>
References: <1388726661-3391-1-git-send-email-Li.Xiubo@freescale.com>
 <20140103074511.GA10680@core.coreip.homeip.net>
 <f9527d65aa234f40af2830d9fb139bbb@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9527d65aa234f40af2830d9fb139bbb@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 09:16:06AM +0000, Li.Xiubo@freescale.com wrote:
> Hi Dmitry,
> 
> > Subject: Re: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
> > 
> > Hi Xiubo,
> > 
> > On Fri, Jan 03, 2014 at 01:24:21PM +0800, Xiubo Li wrote:
> > > +
> > > +static inline int fsl_pwm_calculate_default_ps(struct fsl_pwm_chip *fpc,
> > > +					       enum fsl_pwm_clk index)
> > > +{
> > 
> > Why do you declare this (and other module-local) function as inline?
> > It is usually better let compiler decide if given function should be
> > inlined or not.
> > 
> 
> Could the compiler know when the given function should be inlined by
> not declare it?

Yes.

> And when will be inlined ?

When it makes sense to do so from compiler's point of view: i.e. it is
smallish or with single call site and there are enough registers, etc,
etc.

Thanks.

-- 
Dmitry
