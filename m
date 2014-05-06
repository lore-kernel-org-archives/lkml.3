Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbaEFDqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:46:35 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:40688 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606AbaEFDqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:46:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxSAy2ePfNzFyb7rQ+M6UFxW9rHCMEcQaVbc5zVeNAn-g@mail.gmail.com>
References: <20140505.165756.1229178386133288960.davem@davemloft.net>
	<20140505210507.GA5130@ravnborg.org>
	<20140505.170855.814445464231092040.davem@davemloft.net>
	<20140505.232550.1139149215179650645.davem@davemloft.net>
	<CA+55aFxSAy2ePfNzFyb7rQ+M6UFxW9rHCMEcQaVbc5zVeNAn-g@mail.gmail.com>
Date: Mon, 5 May 2014 20:46:32 -0700
X-Google-Sender-Auth: QmHGg2ILWcLDe26DRsb3AXu_muk
Message-ID: <CA+55aFwi7YMSt2k+yES=6HetDxq0aQYSxdmmdbvbn6L9LzE3NQ@mail.gmail.com>
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

On Mon, May 5, 2014 at 8:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I guess I'll apply both patches directly.

Applied and pushed out. Davem, I hope this means current -git works
for you on sparc64 again?

                Linus
