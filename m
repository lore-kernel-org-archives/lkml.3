Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaLJBio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:38:44 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47749 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLJBim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:38:42 -0500
Message-ID: <5487A5AC.8050503@gmail.com>
Date: Wed, 10 Dec 2014 09:45:16 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Minchan Kim <minchan@kernel.org>, "rth@twiddle.net" <rth@twiddle.net>,
        "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>,
        "mattst88@gmail.com" <mattst88@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.net>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Carlos O'Donell" <carlos@systemhalted.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, dietlibc@fefe.de,
        Felix von Leitner <felix@fefe.de>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
References: <5480E715.3020900@gmail.com> <20141205065417.GA3358@bbox> <54822B19.2070804@gmail.com>
In-Reply-To: <54822B19.2070804@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew:

Could you help check this patch, when you have time. And apply it if
possible.

I guess, this patch is a little urgent, since it changes uapi, if wait
a little longer, more user mode programs (e.g. libc) may use MADV_FREE
as various values.

Thanks.

On 12/6/14 06:00, Chen Gang wrote:
> On 12/05/2014 02:54 PM, Minchan Kim wrote:
>> On Fri, Dec 05, 2014 at 06:58:29AM +0800, Chen Gang wrote:
>>> For uapi, need try to let all macros have same value, and MADV_FREE is
>>> added into main branch recently, so need redefine MADV_FREE for it.
>>>
>>> At present, '8' can be shared with all architectures, so redefine it to
>>> '8'.
>>>
>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>
>>
>> Hello Chen,
>>
>> Thanks for looking at this.
>> Feel free to add my sign.
>>
>> Acked-by: Minchan Kim <minchan@kernel.org>
>>
> 
> OK, thanks.
> 
> Originally I sent the same patch like you sent (but later than yours).
> Geert suggested to use same value for MADV_FREE, and Carlos confirmed
> it and suggested more things (sorry, I forgot to Cc them in this mail).
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
