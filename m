Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaLaJpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 04:45:32 -0500
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:54607 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbaLaJpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 04:45:30 -0500
Message-ID: <54A3C5B2.8090501@gentoo.org>
Date: Wed, 31 Dec 2014 04:45:22 -0500
From: Joshua Kinard <kumba@gentoo.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Linux MIPS List <linux-mips@linux-mips.org>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/02 resend] MIPS: IP32: Add platform data hooks to use
 DS1685 driver
References: <548B689A.1010007@gentoo.org> <20141215162957.GC26674@linux-mips.org>
In-Reply-To: <20141215162957.GC26674@linux-mips.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 11:29, Ralf Baechle wrote:
> On Fri, Dec 12, 2014 at 05:13:46PM -0500, Joshua Kinard wrote:
> 
>> This modifies the IP32 (SGI O2) platform and reset code to utilize the new
>> rtc-ds1685 driver.  The old mc146818rtc.h header is removed and ip32_defconfig
>> is updated as well.
>>
>> Signed-off-by: Joshua Kinard <kumba@gentoo.org>
>> ---
>>  arch/mips/configs/ip32_defconfig              |    3
>>  arch/mips/include/asm/mach-ip32/mc146818rtc.h |   36 ----
>>  arch/mips/sgi-ip32/ip32-platform.c            |   52 +++++-
>>  arch/mips/sgi-ip32/ip32-reset.c               |  132 ++++------------
>>  4 files changed, 85 insertions(+), 138 deletions(-)
>>  delete mode 100644 arch/mips/include/asm/mach-ip32/mc146818rtc.h
>>
>> Ralf,
>>
>>   Similar to Maciej's DEC/RTC patches from a few months ago, this patch
>> requires the rtc-ds1685 driver be added upstream first before this can go into
>> into the LMO tree.  If you can queue this someplace until that makes it in,
>> that would be great.  Thanks!
> 
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
> 
> Alessandro,
> 
> I don't think there is much of a chance of this patch conflicting with
> others so feel free to funnel this through the RTC tree.  Or I carry
> both patches - I don't care which way.
> 
> Cheers,
> 
>   Ralf

I haven't seen any reaction or feedback from Alessandro or the rtc-linux
upstream yet.  What are the odds these two patches can go in under the MIPS
tree?  If so, would it be queued for 3.20 or 3.21?

Thanks!,

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
4096R/D25D95E3 2011-03-28
