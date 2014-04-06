Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaDFQJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 12:09:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58683 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaDFQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 12:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140406.113106.564835222660199498.davem@davemloft.net>
References: <533B06A7.5010900@infradead.org>
	<20140401.152203.847120817141929645.davem@davemloft.net>
	<CAMuHMdXaoUvUButpaDYQh6aj=Zm9GCS7MKFA_-h8GOo1RkOObw@mail.gmail.com>
	<20140406.113106.564835222660199498.davem@davemloft.net>
Date: Sun, 6 Apr 2014 18:08:47 +0200
X-Google-Sender-Auth: eLXXwN8M2S-ECkEce8Emfbxf_7M
Message-ID: <CAMuHMdVS8+wMTbUCC9x0zhUq9EJx5RUgWTw8zEnQ4nVTOHugsg@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 1 (netfilter)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, Apr 6, 2014 at 5:31 PM, David Miller <davem@davemloft.net> wrote:
>> On Tue, Apr 1, 2014 at 9:22 PM, David Miller <davem@davemloft.net> wrote:
>>> From: Randy Dunlap <rdunlap@infradead.org>
>>> Date: Tue, 01 Apr 2014 11:34:15 -0700
>>>> on x86_64:
>>>>
>>>> net/netfilter/xt_connlimit.c: In function 'connlimit_mt_check':
>>>> net/netfilter/xt_connlimit.c:380:18: warning: division by zero [-Wdiv-by-zero]
>>>>
>>>> Maybe just use CONNLIMIT_LOCK_SLOTS instead of ARRAY_SIZE(...).
>>>
>>> I'd rather see that ARRAY_SIZE() be adjusted to work cleanly for zero
>>> sized array elements.
>>
>> Anyone with a suggestion?
>>
>> Please note this is now in Linus' tree, possibly crashing people's boxes...
>
> I took in the version of the fix I didn't like via Pablo for
> now.

Thank you!

Fixing ARRAY_SIZE() can still be done later, if possible.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvald
