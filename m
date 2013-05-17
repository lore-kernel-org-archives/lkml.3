Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3EQHvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:51:52 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:62919 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3EQHvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:51:51 -0400
Date: Fri, 17 May 2013 09:51:40 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, arnd@arndb.de,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [GIT PULL v2] MFD: Fixes due for the v3.10 -rc:s
Message-ID: <20130517075140.GA25077@balto.lan>
References: <20130514091956.GG3297@gmail.com>
 <20130515090449.GA3494@gmail.com>
 <20130516224337.GZ22822@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516224337.GZ22822@zurbaran>
X-Operating-System: Linux balto 3.9.0-10518-gd7ab730 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel,

On Fri, May 17, 2013 at 12:43:37AM +0200, Samuel Ortiz wrote:
> > Fabio Baltieri (5):
> >       mfd: abx500-core: Fix sparse warning
> >       mfd: ab8500-sysctrl: Fix sparse warning
> >       mfd: ab8500-sysctrl: Set sysctrl_dev during probe
> >       mfd: ab8500-sysctrl: Let sysctrl driver work without pdata
> Unless I'm missing something here, this one is not really rcN material, so
> I'd appreciate if you could queue it to your for-mfd branch instead.

The last two:

  mfd: ab8500-sysctrl: Set sysctrl_dev during probe
  mfd: ab8500-sysctrl: Let sysctrl driver work without pdata

are actually fixes for bugs introduced in this merge window that
inhibited the ab8500-sysctl driver as a consequence.  Would you
reconsider pulling just those?

Thanks,
Fabio

-- 
Fabio Baltieri
