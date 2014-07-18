Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbaGRCcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 22:32:16 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:45347 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaGRCcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 22:32:15 -0400
X-CheckPoint: {53C8872E-5-2100090A-C0000000}
Message-ID: <53C8872D.4030900@tilera.com>
Date: Thu, 17 Jul 2014 22:32:13 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 01/55] tile: Convert VDSO timekeeping to the precise mechanism
References: <20140711133623.530368377@linutronix.de> <20140711133705.309823897@linutronix.de>
In-Reply-To: <20140711133705.309823897@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [108.20.112.127]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/2014 9:45 AM, Thomas Gleixner wrote:
> The code was only halfarsed converted to the new VSDO update mechanism
> and still uses the inaccurate base value which lacks the fractional
> part of xtime_nsec. Fix it up.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> ---
>   arch/tile/kernel/time.c               |    9 ++++-----
>   arch/tile/kernel/vdso/vgettimeofday.c |    7 ++++---
>   2 files changed, 8 insertions(+), 8 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

