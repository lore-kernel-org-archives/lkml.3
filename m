Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3FKSDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:03:04 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54516 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3FKSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:03:01 -0400
Message-ID: <51B7664E.9070708@kernel.org>
Date: Tue, 11 Jun 2013 19:02:54 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <20130611142358.GG29135@zurbaran>
In-Reply-To: <20130611142358.GG29135@zurbaran>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 03:23 PM, Samuel Ortiz wrote:
> Hi Sebastian,
> 
> On Tue, Jun 11, 2013 at 01:30:46PM +0200, Sebastian Andrzej Siewior wrote:
>> I believe the whole thing should go via the MFD tree. It touches also
>> input & iio subsystem. I collected ACKs where I got some in the meantime.
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

I'd just like to note for future reference that I would prefer Samuels
approach of such a branch for future cases where things touch on iio
and another subsystem.

Now as I've expressed I am happy with this set going through mfd
but there is never anything wrong with agreeing how things 'should'
be done ;)

> AFAICT, only patch #2 should be kept with input and iio bits mixed
> together with MFD as otherwise this would introduce functional breakage.
> Otherwise, all MFD bits from the other patches could be either separated
> or merged together (e.g. MFD bits from patches #6 and #8, and #16 and
> #17).

> 
> Does that sound doable to you ?
> 
> Cheers,
> Samuel.
> 
