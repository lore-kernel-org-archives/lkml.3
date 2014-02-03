Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaBCQrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:47:15 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:42630 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBCQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:47:14 -0500
Date: Mon, 3 Feb 2014 16:47:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1] fix da9052 volatile register definition ommissions
Message-ID: <20140203164706.GW13529@lee--X1>
References: <201401281723.s0SHNmLa041140@swsrvapps-02.lan>
 <20140203102919.GP13529@lee--X1>
 <24DF37198A1E704D9811D8F72B87EB51AD22E658@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51AD22E658@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Three of the PMIC registers have some bits that are changed
> > > autonomously by the PMIC itself (some time) after being set by some
> > > component driver of the DA9052 PMIC and hence they need to be marked
> > > as volatile so that the regmap API will not cache their values.
> > > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > > Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> > These are not correct.
> > Who authored the patch?
> 
> I found the problem when running regression tests for another different problem.
> And according to my testing on a SMDK6410+DA9053EVB the patch is correct!!

I mean the Signed-off-by's are not correct.

They should be in order of the patch submission path.

Who authored the patch initially and what part did David play?

<snip>

> > > REGULATORS - the first change to any DA9052 BUCK voltage will be
> > >              actioned, but sebsequent ones will not.
> > Which patch caused the bug?
> 
> I will find out when I start rebasing backwards to submit patches to linux-stable!

I'm just wondering where to apply the patch. Either for -fixes or
-next. If the bug has been present for some time, I'll probably just
apply it to my for-next branch.

Also be wary of the $SUBJECT line format when submitting to different
subsystems. You can usually get an idea of what's expected by doing:

  `git log --oneline -- drivers/<subsystem>`

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
