Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3EUI5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:57:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:10631 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab3EUI5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="337503453"
Date: Tue, 21 May 2013 10:56:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, arnd@arndb.de,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [GIT PULL v2] MFD: Fixes due for the v3.10 -rc:s
Message-ID: <20130521085650.GB4589@zurbaran>
References: <20130514091956.GG3297@gmail.com>
 <20130515090449.GA3494@gmail.com>
 <20130516224337.GZ22822@zurbaran>
 <20130517075140.GA25077@balto.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517075140.GA25077@balto.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Fri, May 17, 2013 at 09:51:40AM +0200, Fabio Baltieri wrote:
> Hello Samuel,
> 
> On Fri, May 17, 2013 at 12:43:37AM +0200, Samuel Ortiz wrote:
> > > Fabio Baltieri (5):
> > >       mfd: abx500-core: Fix sparse warning
> > >       mfd: ab8500-sysctrl: Fix sparse warning
> > >       mfd: ab8500-sysctrl: Set sysctrl_dev during probe
> > >       mfd: ab8500-sysctrl: Let sysctrl driver work without pdata
> > Unless I'm missing something here, this one is not really rcN material, so
> > I'd appreciate if you could queue it to your for-mfd branch instead.
> 
> The last two:
> 
>   mfd: ab8500-sysctrl: Set sysctrl_dev during probe
This one is already in mfd-fixes, the commit log was clear enough.


>   mfd: ab8500-sysctrl: Let sysctrl driver work without pdata
This one is not, as the commit log is not showing it actually fixes something
but only makes the code cleaner. If it really fixes something, could you
please provide me with a commit log that describes what exactly it fixes ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
