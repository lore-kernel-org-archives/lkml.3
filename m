Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaGKSlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:41:22 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34146 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaGKSlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:41:20 -0400
Date: Fri, 11 Jul 2014 20:41:02 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 07/55] time64: Add time64.h header and define struct
 timespec64
Message-ID: <20140711184100.GA4500@netboy>
References: <20140711133623.530368377@linutronix.de>
 <20140711133705.830480055@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711133705.830480055@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:44:08PM -0000, Thomas Gleixner wrote:
> From: John Stultz <john.stultz@linaro.org>
> +/*
> + * timespec64_add_safe assumes both values are positive and checks
> + * for overflow. It will return TIME_T_MAX if the reutrn would be
                                                     ^^^^^^
returned value?

> + * smaller then either of the arguments.
> + */
> +extern struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
> +					 const struct timespec64 rhs);

Thanks,
Richard
