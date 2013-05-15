Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3EOHkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:40:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:14964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab3EOHkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:40:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,675,1363158000"; 
   d="scan'208";a="337519597"
Message-ID: <1368603747.13665.20.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V4 1/9] mtd: add more comment for ecc_strength/ecc_size
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 15 May 2013 10:42:27 +0300
In-Reply-To: <51933B79.5000608@freescale.com>
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>
		 <1366967337-5534-2-git-send-email-b32955@freescale.com>
	 <1368602870.13665.7.camel@sauron.fi.intel.com>
	 <51933B79.5000608@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 15:38 +0800, Huang Shijie wrote:
> 于 2013年05月15日 15:27, Artem Bityutskiy 写道:
> > On Fri, 2013-04-26 at 17:08 +0800, Huang Shijie wrote:
> >> Add more commit for ecc_strength and ecc_size fields.
> >> We can treat the comment as the initial semantics for the two fields.
> >>
> >> Signed-off-by: Huang Shijie<b32955@freescale.com>
> > Huang, let me drop the 3 patches I already merged. Please, re-send them
> > in v5. I think this is better because I see you start applying patches
> > on top of them, which is a bit confusing.
> >
> Ok, Please drop the 3 patches.
> 
> >>    * @cellinfo:		[INTERN] MLC/multichip data from chip ident
> >>    * @ecc_strength:	[INTERN] ECC correctability from the datasheet.
> >> + *			The minimum number of bits correctability, if known;
> >> + *			if unknown, set to 0.
> > I find this confusing still. How about this comment.
> >
> > ECC correctability from the datasheet. Minumum amount of bit errors per
> > @ecc_size guaranteed to be correctable). If unknown, set to zero.
> >
> >
> it's okay to me.
> >>    * @ecc_size:		[INTERN] ECC size required by the @ecc_strength,
> >> - *                      also from the datasheet.
> >> + *                      also from the datasheet. It is the recommended ECC step
> >> + *			size, if known; if unknown, set to 0.
> > Silly question, why you call this one "ecc_size", and not "ecc_step"?
> >
> In nand_ecc_ctrl{}, the ecc step is named to @size.
> 
> Personally, i perfer to ecc_step.

You could harmonize the naming. Rename all the names to ecc_step, which
is a lot easier to understand.

You did not send v4 thus far, is this because you are busy or you did
not have any requests to address?

Thanks!

-- 
Best Regards,
Artem Bityutskiy

