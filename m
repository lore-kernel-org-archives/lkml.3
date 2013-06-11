Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3FKSmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:42:23 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:59323 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3FKSmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:42:20 -0400
Date: Tue, 11 Jun 2013 19:42:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, "Patil, Rachna" <rachna@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH 10/22] mfd/ti_am335x_tscadc: Add DT support
Message-ID: <20130611184214.GB4320@laptop>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <1370950268-7224-11-git-send-email-bigeasy@linutronix.de>
 <20130611142347.GF29135@zurbaran>
 <51B73756.5010004@linutronix.de>
 <20130611150505.GI29135@zurbaran>
 <51B74540.2020608@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51B74540.2020608@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Sebastian Andrzej Siewior wrote:

> On 06/11/2013 05:05 PM, Samuel Ortiz wrote:
> > Hi Sebastian,
> 
> Hi Samuel,
> 
> > On Tue, Jun 11, 2013 at 04:42:30PM +0200, Sebastian Andrzej Siewior wrote:
> >> In the end I would like not to post a patch with "From: != me" and
> >> don't make change which the original author did not do. Also dropping
> >> their authorship isn't nice. What could we agree on?
> > You probably don't want to change authorship unless the final patch is
> > really far from the original one. In which case you can change it and
> > mention the original author name in the commit log.
> > If you have only made a few changes on top of the original patch, please
> > say so explicitely in the commit log. Don't bother if we're talking
> > about small changes or cosmetic ones. But your commit log has to be
> > readable and clear.
> 
> Commit 06c9494 on of many examples where cosmetic are recorded. But to
> make some progress I rewrite the commit log to resolve this and don't
> add anything to the sign-off area.

If you are submitting the patch, you still have to add your own SOB.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
