Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaLEVuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:50:04 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61639 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLEVuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:50:01 -0500
Message-ID: <548228F5.4020801@gmail.com>
Date: Sat, 06 Dec 2014 05:51:49 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>,
        "mattst88@gmail.com" <mattst88@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.net>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, minchan@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
References: <5480E715.3020900@gmail.com> <20141205001446.GC10064@birch.djwong.org>
In-Reply-To: <20141205001446.GC10064@birch.djwong.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 08:14 AM, Darrick J. Wong wrote:
> On Fri, Dec 05, 2014 at 06:58:29AM +0800, Chen Gang wrote:
>> For uapi, need try to let all macros have same value, and MADV_FREE is
>> added into main branch recently, so need redefine MADV_FREE for it.
>>
>> At present, '8' can be shared with all architectures, so redefine it to
>> '8'.
> 
> Hmmm... you might want to talk to the dietlibc people if you do this:
> 
> $ grep -rn MADV_FREE /usr/include/
> /usr/include/diet/sys/mman.h:101:#define MADV_FREE      0x5             /* (Solaris) contents can be freed */
> 
> Though the sole definition only exists on sparc/powerpc/powerpc64, so who
> knows...
>

Excuse me, I am not quite familiar about dietlibc. If possible, please
help forward this mail to them, and Cc me (if necessary).

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
