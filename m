Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbbAXTgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:36:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbbAXTgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:36:50 -0500
Message-ID: <54C3F435.3070505@redhat.com>
Date: Sat, 24 Jan 2015 14:36:21 -0500
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Daniel Church <dchurch@andplus.com>
CC: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: Re: [PATCH v2 2/2] posix-timers: Exposes DELAYTIMER_MAX constant
 used to govern overruns
References: <[PATCH 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX> <1422121737-3686-1-git-send-email-dchurch@andplus.com> <1422121737-3686-3-git-send-email-dchurch@andplus.com> <alpine.DEB.2.11.1501242015260.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501242015260.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2015 02:20 PM, Thomas Gleixner wrote:
> On Sat, 24 Jan 2015, Daniel Church wrote:
> 
>> POSIX.1-2001 specification of timer_getoverrun() supports constant
>> DELAYTIMER_MAX which prevents overflow and caps overrun count.  Exposes
>> delaytimer_max value to userland via /proc/sys/kernel/delaytimer_max such
> 
> I know that you try to match the posix name, but when looking at the
> prctl w/o knowing about DELAYTIMER_MAX, it's non intuitive.
> 
> Something like posixtimer_max_overruns or if you insist on the
> delaytimer_max part, then let us prepend it with posixtimer_ at least.
> 
> New prctls require an update of Documentation/sysctl/kernel.txt.

Agreed, the name should be self-explanatory and point at POSIX.

The documentation should be detailed and explain exactly what this
is for, what are valid values, and why you would ever want to change
them.

Cheers,
Carlos.

