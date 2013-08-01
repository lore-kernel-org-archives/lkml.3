Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3HAPIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:08:55 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52028 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3HAPIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:08:53 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <51FA7A04.7010305@roeck-us.net>
Date: Thu, 01 Aug 2013 08:08:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Ungerer <gerg@uclinux.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.0.84-stable review
References: <20130625183915.443950649@linuxfoundation.org> <20130625192300.GA10427@roeck-us.net> <CAMuHMdVzqOLTVWHeGEFpkpDTt8hpor9zQpnn4bPDaNEGWnb=SQ@mail.gmail.com> <20130625193951.GF15184@roeck-us.net> <CAMuHMdWK9xorBaTH+Zg9z1XU=JMsSffzGEfv5KHXnMZLX04PCw@mail.gmail.com> <51CB73E3.9000309@uclinux.org> <20130626232951.GA9629@roeck-us.net> <51FA7228.6080306@uclinux.org>
In-Reply-To: <51FA7228.6080306@uclinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 07:35 AM, Greg Ungerer wrote:
> Hi Guenter,
>
> Sorry, I am way behind on this...
>
No problem. Happens to me too.

>> and so on. Not that it tells me anything. I'd guess I have the wrong compiler, but it does
>> build for 3.9, so maybe not. If you have an insight, please let me know.
>
> Yes, this is the wrong compiler. You needed to use a m68k-uclinux
> targeted toolchain for 3.0 and older kernels. There are changes to
> the m68k arch Makefile and linker scripts on newer kernels that mean
> you can now use an m68k-linux- toolchain (that is why 3.9 compiles
> cleanly).
>
> Its reasonably easy to fix this on 3.0.x kernels if you want this.
> The below patch does it. I don't have any firm opinion on whether
> you want to apply this to the stable 3.0.x tree. Anyone using 3.0.x
> on m68knommu  has always had to use a m68k-uclinux- toolchain up to
> now.
>
I don't think so. Of course, it would simplify my life, but then it appears
everyone using any of those kernels already knows what to do. So all the patch
really does is to make my life easier, at the cost of adding risk for everyone else.
That does not seem to be worth the trouble.

I'll see if I can update my scripts to use the correct compiler for 3.0 instead.

Thanks,
Guenter

