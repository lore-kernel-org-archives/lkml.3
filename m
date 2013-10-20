Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3JTT2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 15:28:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50461 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3JTT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 15:28:14 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52642EC7.7070901@roeck-us.net>
Date: Sun, 20 Oct 2013 12:28:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [000/121] 3.2.51-rc1 review
References: <lsq.1378608720.401499712@decadent.org.uk>		 <522C22DB.9080008@roeck-us.net>		 <CAMuHMdW6TGdfi+FH=hRWY_hhs5Cb5N9xV1OL0O9Dcs+PfXm2xA@mail.gmail.com>		 <522CAB38.2010909@roeck-us.net>	 <1382270174.2794.96.camel@deadeye.wl.decadent.org.uk>	 <52640379.8070609@roeck-us.net> <1382292356.2794.116.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1382292356.2794.116.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2013 11:05 AM, Ben Hutchings wrote:
> On Sun, 2013-10-20 at 09:23 -0700, Guenter Roeck wrote:
>> On 10/20/2013 04:56 AM, Ben Hutchings wrote:
>>> On Sun, 2013-09-08 at 09:52 -0700, Guenter Roeck wrote:
>>>> On 09/08/2013 01:18 AM, Geert Uytterhoeven wrote:
>>>>> On Sun, Sep 8, 2013 at 9:10 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>> m68k-linux-ld: error: no memory region specified for loadable section
>>>>>> `.note.gnu.build-id'
>>>>>
>>>>> I can't seem to find an explicit fix for that since v3.2.
>>>>> Perhaps the fix is a side effect of f84f52a5c15db7d14a534815f27253b001735183
>>>>> ("m68knommu: clean up linker script").
>>>>>
>>>>
>>>> Kind of. Turns out it requires the following patches.
>>>>
>>>> 40c1b9cf (m68k: consolidate the vmlinux.lds linker scripts)
>>>> ed865e31 (m68k: use non-MMU linker script for ColdFire MMU builds)
>>>> f84f52a5 (m68knommu: clean up linker script)
>>>>
>>>> With those patches applied, all my m68k builds (mmu and nommu) pass with 3.2.
>>>
>>> I've queued these up for 3.2.  The first looks quite a big change in
>>> terms of lines, but most of that is just renaming a file so I think it's
>>> within the spirit of the stable rules.  The third is also pretty big as
>>> m68knommu seems so broken in 3.2 that I suppose it is OK.
>>>
>>> Ben.
>>>
>> Hi Ben,
>>
>> is that in your patch list yet ? Just wondering, because the latest nommu build still failed.
>
> I've only just pushed them.
>

Yes, I see that m68k-nommu build failures are all gone now.

Great!

Thanks,
Guenter

