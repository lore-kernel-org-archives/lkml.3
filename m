Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3AOUeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:34:12 -0500
Received: from xes-mad.com ([216.165.139.218]:40078 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab3AOUeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:34:10 -0500
Date: Tue, 15 Jan 2013 14:34:06 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: =?iso-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] lpc_ich: fix gpio base and control offsets
Message-ID: <eaf72173-bdb9-4839-a8cb-1e80c535aa1e@zimbra>
In-Reply-To: <20130115212904.6c8e96ad@palee-debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC20 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  #define ACPIBASE_GCS_END	0x3414
> >  
> >  #define GPIOBASE		0x48
> > +#define GPIOBASE_ICH5		0x58
> >  #define GPIOCTRL		0x4C
> > +#define GPIOCTRL_ICH5		0x58
> >  
> >  #define RCBABASE		0xf0
> 
> Aaron,
> A like this corrected patch and a little fix that GPIOCTRL_ICH5 is
> 0x5C
> Is this correct? Thanks!

Yes, of course you're still right about the register offset. Sorry for merging poorly.

-Aaron
