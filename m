Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaLEV7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:59:02 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48440 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaLEV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:59:00 -0500
Message-ID: <54822B19.2070804@gmail.com>
Date: Sat, 06 Dec 2014 06:00:57 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
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
        "Carlos O'Donell" <carlos@systemhalted.org>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
References: <5480E715.3020900@gmail.com> <20141205065417.GA3358@bbox>
In-Reply-To: <20141205065417.GA3358@bbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 02:54 PM, Minchan Kim wrote:
> On Fri, Dec 05, 2014 at 06:58:29AM +0800, Chen Gang wrote:
>> For uapi, need try to let all macros have same value, and MADV_FREE is
>> added into main branch recently, so need redefine MADV_FREE for it.
>>
>> At present, '8' can be shared with all architectures, so redefine it to
>> '8'.
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> 
> Hello Chen,
> 
> Thanks for looking at this.
> Feel free to add my sign.
> 
> Acked-by: Minchan Kim <minchan@kernel.org>
> 

OK, thanks.

Originally I sent the same patch like you sent (but later than yours).
Geert suggested to use same value for MADV_FREE, and Carlos confirmed
it and suggested more things (sorry, I forgot to Cc them in this mail).


Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
