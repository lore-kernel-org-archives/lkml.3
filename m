Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3IKLSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:18:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:9938 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab3IKLSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:18:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,883,1371106800"; 
   d="scan'208";a="358908394"
Date: Wed, 11 Sep 2013 14:24:06 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
Message-ID: <20130911112406.GB7393@intel.com>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <3397524.g9aUWuArnm@vostro.rjw.lan>
 <20130910213522.GG29403@sirena.org.uk>
 <2029393.u6DaKBPszu@vostro.rjw.lan>
 <522FC0DC.9030708@intel.com>
 <20130911095552.GI29403@sirena.org.uk>
 <20130911110543.GA7393@intel.com>
 <20130911111409.GO29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911111409.GO29403@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 12:14:09PM +0100, Mark Brown wrote:
> On Wed, Sep 11, 2013 at 02:05:43PM +0300, Mika Westerberg wrote:
> 
> > I'll also look into converting the existing I2C client drivers to use this
> > method. One question, though, is it better to have the conversion in the
> > same patch that introduces the I2C core runtime PM change or as a separate
> > patch?
> 
> In theory it ought to be part of the same patch but in practice a brief
> bit of bisection breakage on a single branch is probably worth the ease
> of review from my point of view, others may disagree though.

OK, I'll keep them separate, unless there are objections.

> Like I say I think you'll need to convert SPI at the same time due to the
> devices with both buses sharing code.

Yes, I'm looking into that :)
