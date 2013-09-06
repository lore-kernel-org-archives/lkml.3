Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3IFLIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:08:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:49798 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab3IFLIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:08:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,853,1371106800"; 
   d="scan'208";a="399317866"
Date: Fri, 6 Sep 2013 13:08:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Mark Brown <broonie@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: DA9063 driver development
Message-ID: <20130906110818.GA3696@zurbaran>
References: <6ED8E3B22081A4459DAC7699F3695FB732FD0B57@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB732FD0B57@SW-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

See my answers below:

On Fri, Sep 06, 2013 at 10:47:58AM +0000, Steve Twiss wrote:
> Hello,
> 
> I am late into the discussion about the DA9063 driver because I missed
> the e-mail thread around 24th July 
> (https://lkml.org/lkml/2013/7/24/460)
> so I only recently noticed that a DA9063 driver from Philipp Zabel 
> had been submitted and accepted to linux-next.
> 
> I also noted that this driver was using a previous patch-set as its baseline;
> sent by Krystian Garbaciak over a year ago. Given that this original 
> patch-set was not accepted, and the production of the DA9063 chip has 
> advanced since the last submission, we were holding off the final DA9063 
> driver until later. 
> 
> As I discussed earlier in https://lkml.org/lkml/2013/6/28/170 I was in 
> the process of getting this driver ready for submission to the kernel.
> 
> It is well understood that any early submission of our driver to the 
> community (around v3.6) meant that this sort of external driver development 
> could happen without any further input from Dialog. However, this driver:
> 
> - is based on something that is a year old and now out of date; 
> - it cannot support the most recent mass-production release of DA9063 silicon; 
> 
> Is it possible to remove this driver from linux-next so these issues 
> can be resolved by Dialog?
Unfortunately it's too late for that. I sent a pull request to Linus
with this driver included, so I expect it to hit Linus' tree anytime
soon.
That means that it will be part of the 3.12-rc1 release. The good news
here is that we have about 8 weeks to modify it to match your recent
development, before 3.12 is released.
I would really prefer to modify the now existing driver and improve it,
rather than revert it.

Cheers,
Samuel.





> Regards,
> Steve Twiss
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
