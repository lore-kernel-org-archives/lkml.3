Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaDFNuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:50:09 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36837 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaDFNuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:50:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140401.152203.847120817141929645.davem@davemloft.net>
References: <20140401183907.a5127cadbe7116261096beaa@canb.auug.org.au>
	<533B06A7.5010900@infradead.org>
	<20140401.152203.847120817141929645.davem@davemloft.net>
Date: Sun, 6 Apr 2014 15:50:04 +0200
X-Google-Sender-Auth: 8rf3adY5rBSB5Kc_Xr_sumRMp2k
Message-ID: <CAMuHMdXaoUvUButpaDYQh6aj=Zm9GCS7MKFA_-h8GOo1RkOObw@mail.gmail.com>
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

On Tue, Apr 1, 2014 at 9:22 PM, David Miller <davem@davemloft.net> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> Date: Tue, 01 Apr 2014 11:34:15 -0700
>
>> on x86_64:
>>
>> net/netfilter/xt_connlimit.c: In function 'connlimit_mt_check':
>> net/netfilter/xt_connlimit.c:380:18: warning: division by zero [-Wdiv-by-zero]
>>
>> Maybe just use CONNLIMIT_LOCK_SLOTS instead of ARRAY_SIZE(...).
>
> I'd rather see that ARRAY_SIZE() be adjusted to work cleanly for zero
> sized array elements.

Anyone with a suggestion?

Please note this is now in Linus' tree, possibly crashing people's boxes...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
