Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3FKQE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:04:29 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50113 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3FKQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:04:25 -0400
Date: Tue, 11 Jun 2013 09:04:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
Message-ID: <20130611160415.GA379@core.coreip.homeip.net>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <20130611142358.GG29135@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611142358.GG29135@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Tue, Jun 11, 2013 at 04:23:58PM +0200, Samuel Ortiz wrote:
> Hi Sebastian,
> 
> On Tue, Jun 11, 2013 at 01:30:46PM +0200, Sebastian Andrzej Siewior wrote:
> > I believe the whole thing should go via the MFD tree. It touches also
> > input & iio subsystem. I collected ACKs where I got some in the meantime.
> Please fix your commit logs, and your subject lines. It should be e.g.
> mfd: input: ti_am335x_adc: Blablabla
> 
> if it's mostly an mfd patch that also touches an input driver.
> 
> Then, this is a pretty big patchset, with iio, input and mfd all mixed
> together and it is likely to create merge conflicts.
> From what I can see from it, and please correct me if I'm
> wrong, the iio and input changes depend on the mfd ones, and not the
> other way around. If that's so, I'm going to ask you to reshuffle your
> patch set and separate the MFD changes from the iio and input ones. I'll
> take the MFD ones and will create an immutable branch for Jonathan and
> Dmitry to pull from and apply the iio and input changes on top of it.
> Merge conflicts should be mostly avoided that way.

I purposely left this driver alone as I expected it would be merged
through MFD tree, so there should not be any merging issues on my side.

Thanks.

-- 
Dmitry
