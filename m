Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaBQLW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 06:22:57 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34349 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaBQLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:22:55 -0500
Date: Mon, 17 Feb 2014 11:22:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Jenny Tc <jenny.tc@intel.com>
Subject: Re: [PATCH v3 14/15] charger: max14577: Configure battery-dependent
 settings from DTS
Message-ID: <20140217112248.GB20218@lee--X1>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
 <1392627950-26927-15-git-send-email-k.kozlowski@samsung.com>
 <20140217100735.GA20218@lee--X1>
 <1392633657.11078.4.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392633657.11078.4.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
> > > index a8cd7de3526a..fc69d7beb1aa 100644
> > > --- a/include/linux/mfd/max14577-private.h
> > > +++ b/include/linux/mfd/max14577-private.h
> > > @@ -269,6 +269,20 @@ enum maxim_muic_charger_type {
> > >  #define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP	 25000U
> > >  #define MAX77836_CHARGER_CURRENT_LIMIT_MAX		475000U
> > >  
> > > +/* MAX14577 charger End-Of-Charge current limits
> > > + * (as in MAXIM_CHGCTRL5 register), uA
> > > + */
> > > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN		50000U
> > > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_STEP		10000U
> > > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MAX		200000U
> > > +
> > > +/* MAX14577/MAX77836 Battery Constant Voltage
> > > + * (as in MAXIM_CHGCTRL3 register), uV
> > > + */
> > 
> > These are not proper multi-line comments.
> > 
> > Documentation/CodingSytle:
> > 
> >  The preferred style for long (multi-line) comments is:
> >  
> >          /*
> >           * This is the preferred style for multi-line
> >           * comments in the Linux kernel source code.
> >           * Please use it consistently.
> >           *
> >           * Description:  A column of asterisks on the left side,
> >           * with beginning and ending almost-blank lines.
> >           */
> 
> Sure. Sorry for bugging with such trivial mistakes.

That's okay.

Just fix it up and apply my:
  Acked-by: Lee Jones <lee.jones@linaro.org>

No need to resubmit over this. Concentrate on the other Acks now.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
