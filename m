Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab3FMJIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:08:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:39955 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab3FMJH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:07:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,857,1363158000"; 
   d="scan'208";a="352754750"
Date: Thu, 13 Jun 2013 11:07:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 5
Message-ID: <20130613090719.GB7998@zurbaran>
References: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Wed, Jun 12, 2013 at 06:58:01PM +0200, Sebastian Andrzej Siewior wrote:
> Hi Samuel,
> 
> I did the cosmetic changes of the subject line and removed the changes
> from within the sob lines in each patch. I dropped the "#define XPP
> STEPCONFIG_XPP" thingy and patch #1 which removed regmap from mfd. Not
> that I agree with it, I just do not want to miss the merge window due to
> this.
> 
> The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:
> 
>   Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)
> 
> are available in the git repository at:
> 
>   git://breakpoint.cc/bigeasy/linux tags/am335x_tsc-adc
Pulled and pushed back to mfd-next, thanks.
I fixed a couple of unused variable warnings on top of it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
