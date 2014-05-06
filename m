Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854AbaEFDcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:32:16 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:38176 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbaEFDcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140505.232550.1139149215179650645.davem@davemloft.net>
References: <20140505.165756.1229178386133288960.davem@davemloft.net>
	<20140505210507.GA5130@ravnborg.org>
	<20140505.170855.814445464231092040.davem@davemloft.net>
	<20140505.232550.1139149215179650645.davem@davemloft.net>
Date: Mon, 5 May 2014 20:32:14 -0700
X-Google-Sender-Auth: sx_BMFmw3y3K39MbCuF50YLe8fg
Message-ID: <CA+55aFxSAy2ePfNzFyb7rQ+M6UFxW9rHCMEcQaVbc5zVeNAn-g@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix off by one in object max number tests.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, sparclinux@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 8:25 PM, David Miller <davem@davemloft.net> wrote:
>
>> Sam Ravnborg <sam@ravnborg.org> wrote:
>>>
>>> There is a related patch in this area which I think is not yet applied.
>>>
>>> See: https://lkml.org/lkml/2014/4/18/28
>>>
>>> Maybe this is related.
>>
>> Thanks, I'm testing with that patch added as well.
>
> I can confirm that this fixes my problems completely.

Ugh. That patch has been out two weeks already. Pekka?

I guess I'll apply both patches directly.

              Linus
