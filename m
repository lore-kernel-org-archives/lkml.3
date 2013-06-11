Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3FKQ2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:28:12 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52943 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3FKQ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:28:10 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130611161506.GK29135@zurbaran>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <20130611142358.GG29135@zurbaran> <20130611160415.GA379@core.coreip.homeip.net> <20130611161506.GK29135@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
From: Jonathan Cameron <jic23@kernel.org>
Date: Tue, 11 Jun 2013 17:27:48 +0100
To: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org
Message-ID: <1565f2fb-7f16-4910-8fa2-cd5700e8986d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Samuel Ortiz <sameo@linux.intel.com> wrote:

>Hi Dmitry,
>
>On Tue, Jun 11, 2013 at 09:04:16AM -0700, Dmitry Torokhov wrote:
>> On Tue, Jun 11, 2013 at 04:23:58PM +0200, Samuel Ortiz wrote:
>> > Hi Sebastian,
>> > 
>> > On Tue, Jun 11, 2013 at 01:30:46PM +0200, Sebastian Andrzej Siewior
>wrote:
>> > > I believe the whole thing should go via the MFD tree. It touches
>also
>> > > input & iio subsystem. I collected ACKs where I got some in the
>meantime.
>> > Please fix your commit logs, and your subject lines. It should be
>e.g.
>> > mfd: input: ti_am335x_adc: Blablabla
>> > 
>> > if it's mostly an mfd patch that also touches an input driver.
>> > 
>> > Then, this is a pretty big patchset, with iio, input and mfd all
>mixed
>> > together and it is likely to create merge conflicts.
>> > From what I can see from it, and please correct me if I'm
>> > wrong, the iio and input changes depend on the mfd ones, and not
>the
>> > other way around. If that's so, I'm going to ask you to reshuffle
>your
>> > patch set and separate the MFD changes from the iio and input ones.
>I'll
>> > take the MFD ones and will create an immutable branch for Jonathan
>and
>> > Dmitry to pull from and apply the iio and input changes on top of
>it.
>> > Merge conflicts should be mostly avoided that way.
>> 
>> I purposely left this driver alone as I expected it would be merged
>> through MFD tree, so there should not be any merging issues on my
>side.
>Thanks for the notice.
>Jonathan, can you guarantee the same for the iio parts ?
I have also been avoiding taking any of these and there are unlikely to be any iio wide changes merging at this stage in cycle.  Hence these going through MFD is best plan.

Lars raised a couple of issues so would be best to wait for his ack if he hasn't already looked at this revision.

Thanks

Jonathan. 
>
>Sabastian, hold on before reworking your patchset.
>
>Cheers,
>Samuel.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
