Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaLOQaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:30:05 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:48610 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaLOQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:30:02 -0500
Date: Mon, 15 Dec 2014 17:29:58 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Joshua Kinard <kumba@gentoo.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Linux MIPS List <linux-mips@linux-mips.org>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/02 resend] MIPS: IP32: Add platform data hooks to use
 DS1685 driver
Message-ID: <20141215162957.GC26674@linux-mips.org>
References: <548B689A.1010007@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548B689A.1010007@gentoo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 05:13:46PM -0500, Joshua Kinard wrote:

> This modifies the IP32 (SGI O2) platform and reset code to utilize the new
> rtc-ds1685 driver.  The old mc146818rtc.h header is removed and ip32_defconfig
> is updated as well.
> 
> Signed-off-by: Joshua Kinard <kumba@gentoo.org>
> ---
>  arch/mips/configs/ip32_defconfig              |    3
>  arch/mips/include/asm/mach-ip32/mc146818rtc.h |   36 ----
>  arch/mips/sgi-ip32/ip32-platform.c            |   52 +++++-
>  arch/mips/sgi-ip32/ip32-reset.c               |  132 ++++------------
>  4 files changed, 85 insertions(+), 138 deletions(-)
>  delete mode 100644 arch/mips/include/asm/mach-ip32/mc146818rtc.h
> 
> Ralf,
> 
>   Similar to Maciej's DEC/RTC patches from a few months ago, this patch
> requires the rtc-ds1685 driver be added upstream first before this can go into
> into the LMO tree.  If you can queue this someplace until that makes it in,
> that would be great.  Thanks!

Acked-by: Ralf Baechle <ralf@linux-mips.org>

Alessandro,

I don't think there is much of a chance of this patch conflicting with
others so feel free to funnel this through the RTC tree.  Or I carry
both patches - I don't care which way.

Cheers,

  Ralf
