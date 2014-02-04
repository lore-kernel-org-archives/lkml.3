Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935251AbaBDVwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:52:55 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:47666 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618AbaBDVwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:52:31 -0500
Date: Tue, 4 Feb 2014 22:52:21 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/37] 3.4.79-stable review
Message-ID: <20140204215221.GA2127@bender.morinfr.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20140204210055.992134150@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204210055.992134150@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04 Feb 13:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.79 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> (snip)
> Borislav Petkov <bp@alien8.de>
>     rtc-cmos: Add an alarm disable quirk

This is just one of the 3 patches posted by John Stultz on
http://git.linaro.org/people/john.stultz/linux.git/shortlog/refs/heads/stable/3.4/timefix

The other 2 are backports of 6fdda9a9c5db367130cf32df5d6618d08b89f46a
(timekeeping: Avoid possible deadlock from clock_was_set_delayed) and
ec145babe754f9ea1079034a108104b6001e001c (timekeeping: fix 32-bit
overflow in get_monotonic_boottime)

Could you explain why there were not included?  Are you simply planning
to include these in 3.4.80?

Sorry if this was discussed somewhere but the original thread does not
say when/if they are going to be included in 3.4.  If this information
is somewhere else, could you just point me to the discussion?

Thanks in advance for your help,

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
