Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935663AbaBDWKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:10:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934289AbaBDWKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:10:03 -0500
Date: Tue, 4 Feb 2014 14:11:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/37] 3.4.79-stable review
Message-ID: <20140204221109.GA906@kroah.com>
References: <20140204210055.992134150@linuxfoundation.org>
 <20140204215221.GA2127@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204215221.GA2127@bender.morinfr.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 10:52:21PM +0100, Guillaume Morin wrote:
> On 04 Feb 13:00, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.79 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > (snip)
> > Borislav Petkov <bp@alien8.de>
> >     rtc-cmos: Add an alarm disable quirk
> 
> This is just one of the 3 patches posted by John Stultz on
> http://git.linaro.org/people/john.stultz/linux.git/shortlog/refs/heads/stable/3.4/timefix

I have no idea what that tree is, nor what I am supposed to do with it.

> The other 2 are backports of 6fdda9a9c5db367130cf32df5d6618d08b89f46a
> (timekeeping: Avoid possible deadlock from clock_was_set_delayed) and
> ec145babe754f9ea1079034a108104b6001e001c (timekeeping: fix 32-bit
> overflow in get_monotonic_boottime)
> 
> Could you explain why there were not included?

Can you explain why I would include them?

> Are you simply planning to include these in 3.4.80?

I have no idea what people send me in the future...

> Sorry if this was discussed somewhere but the original thread does not
> say when/if they are going to be included in 3.4.

What original thread?

confused,

greg k-h
