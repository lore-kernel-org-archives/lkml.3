Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3FZXGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:06:33 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:36358 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470Ab3FZXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:06:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBADdzy1HYNY97/2dsb2JhbAANTocJu36BGoMXAQEBBCMPAQVAARALGAICBRYLAgIJAwIBAgFFBg0BBQIBAa9sc5E7gSaOJQeCT4EUA6wt
X-IronPort-AV: E=Sophos;i="4.87,947,1363104000"; 
   d="scan'208";a="346268800"
X-WN-REMOTEIP: 216.53.143.123
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 346268800
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <51CB73E3.9000309@uclinux.org>
Date: Thu, 27 Jun 2013 09:06:11 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.0.84-stable review
References: <20130625183915.443950649@linuxfoundation.org> <20130625192300.GA10427@roeck-us.net> <CAMuHMdVzqOLTVWHeGEFpkpDTt8hpor9zQpnn4bPDaNEGWnb=SQ@mail.gmail.com> <20130625193951.GF15184@roeck-us.net> <CAMuHMdWK9xorBaTH+Zg9z1XU=JMsSffzGEfv5KHXnMZLX04PCw@mail.gmail.com>
In-Reply-To: <CAMuHMdWK9xorBaTH+Zg9z1XU=JMsSffzGEfv5KHXnMZLX04PCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/13 17:34, Geert Uytterhoeven wrote:
> On Tue, Jun 25, 2013 at 9:39 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On Tue, Jun 25, 2013 at 09:32:26PM +0200, Geert Uytterhoeven wrote:
>>> Hi Günther,
>>>
>>> On Tue, Jun 25, 2013 at 9:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>> Build m68k:defconfig passed
>>>> Build m68k:apollo_defconfig passed
>>>> Build m68k:m5272c3_defconfig failed
>>>> Build m68k:m5307c3_defconfig failed
>>>> Build m68k:m5249evb_defconfig failed
>>>> Build m68k:m5407c3_defconfig failed
>>>> Build m68k:mac_defconfig passed
>>>> Build m68k:multi_defconfig passed
>>>> Build m68k:sun3_defconfig passed
>>>> Build m68k:sun3x_defconfig passed
>>>> Build m68k:mvme16x_defconfig passed
>>>> Build m68k:hp300_defconfig passed
>>>
>>> m68k:defconfig is an alias for m68k:multi_defconfig, so you can drop
>>> one of them.
>>>
>>> Furthermore, m68k:multi_defconfig is the union of all m68k "classic MMU"
>>> defconfigs, except for sun3_defconfig (due to the incompatible MMU type).
>>> Hence dropping apollo_defconfig, mac_defconfig, sun3x_defconfig,
>>> mvme16x_defconfig, and hp300_defconfig would reduce your build coverage
>>> only marginally. Of course, if you have too many spare cycles ;-)
>>>
>> Thanks, I'll do that. The complete build for three releases takes 15+ hours
>> with i7-3700k, so reducing that a bit doesn't hurt.
>
> FYI, you still built m68k:mvme16x_defconfig for v3.9.7-95-g6a2f14b.
>
>> Would there be any useful builds to add ?
>
> You could add m68k:m5475evb_defconfig, which is the only Coldfire
> defconfig with MMU=y.
>
> Greg: Any other advice for Coldfire?

I might have some, except I am not sure what we are talking about.
I don't have enough context from the above alone :-)

I take it this is test building 3.0.84?
I haven't built a 3.0.x for a while, so not sure why the above
ColdFire targets are failing without going and trying it out.

Regards
Greg


