Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab3J1QqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:46:09 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33392 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3J1QqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <3901382977358@web14h.yandex.ru>
References: <55541379679397@web20h.yandex.ru> <CAP+RiCAVuUEfyjg02+ZjeFXgUuaRW+fuMB490Ce2Hq_4qHBL=A@mail.gmail.com>
 <loom.20131023T201657-894@post.gmane.org> <237221382623942@web21m.yandex.ru>
 <106621382627723@web13g.yandex.ru> <3901382977358@web14h.yandex.ru>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 28 Oct 2013 09:45:23 -0700
Message-ID: <CAGVrzcYj91m=rC5ye9eAo=eMN0mBzk9-Bv8K6myTpnH28PLUxQ@mail.gmail.com>
Subject: Re: lz4hc compression in UBIFS?
To: Konstantin Tokarev <annulen@yandex.ru>
Cc: Yann Collet <yann.collet.73@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Brent Taylor <motobud@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/28 Konstantin Tokarev <annulen@yandex.ru>:
>
>
> 24.10.2013, 19:15, "Konstantin Tokarev" <annulen@yandex.ru>:
>> Attached patch to crypto API wrapper for lz4hc seems to fix the issue. I can save
>> and read files on LZ4HC-compressed volume, and I'm running on LZ4HC-compressed rootfs,
>> flashed from mkfs.ubifs generated image (patch by Elie De Brauwer). My software
>> works correctly.
>>
>> Unfortunately, on my board LZ4HC-compressed UBIFS volume performs noticeable worse
>> than LZO, while still faster than zlib. I guess the reason is that CPU is no longer a
>> bottleneck for my system, but NAND speed.
>>
>> Thank you all for your help!
>
> Can anyone review the correctness of my patch? Looks like API of LZ4 decompressor is
> used wrong way in crypto API.

Can you make a formal submission of it? That would probably help reviewing it.
--
Florian
