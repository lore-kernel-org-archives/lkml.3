Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab3FLNu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:50:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:1595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab3FLNux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,852,1363158000"; 
   d="scan'208";a="315873128"
Date: Wed, 12 Jun 2013 15:50:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
Message-ID: <20130612135042.GO29135@zurbaran>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <20130611142358.GG29135@zurbaran>
 <20130611160415.GA379@core.coreip.homeip.net>
 <20130611161506.GK29135@zurbaran>
 <1565f2fb-7f16-4910-8fa2-cd5700e8986d@email.android.com>
 <20130611175519.GL29135@zurbaran>
 <51B877C7.8080001@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B877C7.8080001@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Wed, Jun 12, 2013 at 03:29:43PM +0200, Sebastian Andrzej Siewior wrote:
> On 06/11/2013 07:55 PM, Samuel Ortiz wrote:
> > Hi Jonathan,
> 
> Hi Samuel,
> 
> > Sebastian, please address the commit log and cosmetic issues I pointed out,
> > keep the regmap code and I'll pull this patchset in.
>
> By keep the regmap code you mean I am allowed to remove the regmap
> usage in mfd (keep patch #1) or do you insist on adding its usage in
> iio and input?
I insist on keeping it on the MFD driver, i.e. _not_ keeping patch #1.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
