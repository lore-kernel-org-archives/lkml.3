Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3IIN03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:26:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52954 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3IIN0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:26:25 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522DCC7E.2090901@roeck-us.net>
Date: Mon, 09 Sep 2013 06:26:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Ungerer <gerg@uclinux.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [000/121] 3.2.51-rc1 review
References: <lsq.1378608720.401499712@decadent.org.uk> <522C22DB.9080008@roeck-us.net> <CAMuHMdW6TGdfi+FH=hRWY_hhs5Cb5N9xV1OL0O9Dcs+PfXm2xA@mail.gmail.com> <522DCA39.4090505@uclinux.org>
In-Reply-To: <522DCA39.4090505@uclinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 06:16 AM, Greg Ungerer wrote:
> On 08/09/13 18:18, Geert Uytterhoeven wrote:
>> On Sun, Sep 8, 2013 at 9:10 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>> m68k-linux-ld: error: no memory region specified for loadable section
>>> `.note.gnu.build-id'
>>
>> I can't seem to find an explicit fix for that since v3.2.
>> Perhaps the fix is a side effect of f84f52a5c15db7d14a534815f27253b001735183
>> ("m68knommu: clean up linker script").
>>
>> Greg, any idea?
>
> Looks like Guenter found follow up patches that fix it. I don't recall
> this specific change breaking like this at the time though.
>

I think .note.gnu.build-id is a relatively recent addition. May well be that
compilers / linkers used at the time didn't generate it.

Guenter

