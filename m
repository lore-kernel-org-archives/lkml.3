Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3EPWnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:43:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:45727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3EPWnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:43:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="242704203"
Date: Fri, 17 May 2013 00:43:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, arnd@arndb.de,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [GIT PULL v2] MFD: Fixes due for the v3.10 -rc:s
Message-ID: <20130516224337.GZ22822@zurbaran>
References: <20130514091956.GG3297@gmail.com>
 <20130515090449.GA3494@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515090449.GA3494@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, May 15, 2013 at 10:04:49AM +0100, Lee Jones wrote:
> Hi Sam,
> 
> Since v1 of my MFD -fixes pull-request, I have applied a few more
> patches which really should be entered into the -rc:s. As it appears
> that you have not yet pulled v1, I figured sending a v2 in its place
> would be appropriate, so here it is.
This almost looks good, I just have one comment:

> Fabio Baltieri (5):
>       mfd: abx500-core: Fix sparse warning
>       mfd: ab8500-sysctrl: Fix sparse warning
>       mfd: ab8500-sysctrl: Set sysctrl_dev during probe
>       mfd: ab8500-sysctrl: Let sysctrl driver work without pdata
Unless I'm missing something here, this one is not really rcN material, so
I'd appreciate if you could queue it to your for-mfd branch instead.

The rest is pulled and applied, thanks again.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
