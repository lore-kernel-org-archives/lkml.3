Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3A0V2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 16:28:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:65225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307Ab3A0V2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 16:28:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="253289870"
Date: Sun, 27 Jan 2013 22:28:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 0/4] mfd: palma: add RTC and GPIO support
Message-ID: <20130127212836.GK1174@sortiz-mobl>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
 <20130127002821.GF1174@sortiz-mobl>
 <5104E937.1090008@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5104E937.1090008@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Sun, Jan 27, 2013 at 02:15:43PM +0530, Laxman Dewangan wrote:
> On Sunday 27 January 2013 05:58 AM, Samuel Ortiz wrote:
> >Hi Laxman,
> >
> >On Thu, Jan 03, 2013 at 04:16:56PM +0530, Laxman Dewangan wrote:
> >>This series add the RTC and gpio driver for the TI Palma series PMIC.
> >>The changes are splitted so that easy to apply in different sub systems.
> >>
> >>Laxman Dewangan (4):
> >>   mfd: palmas: add rtc irq number as irq resource for palmas-rtc
> >>   mfd: palmas: add apis to access the Palmas' registers
> >>   gpio: palmas: Add support for Palams GPIO
> >>   rtc: palmas: add RTC driver Palmas series PMIC
> >All 4 patches applied to my for-next branch, thanks.
> Hi Samuel,
> 
> Thanks for taking care. But it seems 2/4 of this series is missed
> which is very important for 3/4 and 4/4 to be compile.
> 
> Can you please apply the 2/4 before 3/4 and 4/4?

Patch #2 is applied, see:

http://git.kernel.org/?p=linux/kernel/git/sameo/mfd-2.6.git;a=commit;h=2c3a09ab5da9ef4438af445d8f051e92bac85616

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
