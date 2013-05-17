Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3EQIeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:34:08 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51815 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3EQIeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:34:05 -0400
Date: Fri, 17 May 2013 10:33:54 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [GIT PULL v2] MFD: Fixes due for the v3.10 -rc:s
Message-ID: <20130517083354.GA32133@balto.lan>
References: <20130514091956.GG3297@gmail.com>
 <20130515090449.GA3494@gmail.com>
 <20130516224337.GZ22822@zurbaran>
 <20130517075140.GA25077@balto.lan>
 <CACRpkdYpEreHKdUyfcANA9kTRAjVbLbpJkBJCq1Q_pAeOKcdxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYpEreHKdUyfcANA9kTRAjVbLbpJkBJCq1Q_pAeOKcdxw@mail.gmail.com>
X-Operating-System: Linux balto 3.9.0-10518-gd7ab730 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:25:10AM +0200, Linus Walleij wrote:
> On Fri, May 17, 2013 at 9:51 AM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> > Hello Samuel,
> (...)
> > The last two:
> >
> >   mfd: ab8500-sysctrl: Set sysctrl_dev during probe
> >   mfd: ab8500-sysctrl: Let sysctrl driver work without pdata
> >
> > are actually fixes for bugs introduced in this merge window that
> > inhibited the ab8500-sysctl driver as a consequence.  Would you
> > reconsider pulling just those?
> 
> A good way to make sure that patches fixing regressions are applied
> to the -rc series is to indicate in the commit message or even the
> heading that it fixes a regression.
> 
> I usually try to begin such commits with the text:
> 
>   this patch fixes a regression caused by change 018745435
>   "foo: fix bar"...
> 
> Then copying in some crash dump text never hurts :-)
> 
> It makes it very easy for us as subsystem maintainers to pick
> regression fixes.

Right, I actually pointed to the culprit commit (applied during the
merge window) in the message, but I'll try to be more direct next time.
I also agree on the crash dump, but unfortunately this one was failing
silently. :-)

Thanks for the tip!
Fabio

-- 
Fabio Baltieri
