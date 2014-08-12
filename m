Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaHLTHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:07:23 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:56132 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaHLTHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:07:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140809030822.GA9422@gondor.apana.org.au>
References: <20140808075316.GA21919@www.outflux.net>
	<CALZtONBNEg7kzUtwKihQuAU48MNh5NjhZcWoOxe-1-vgWqSLiw@mail.gmail.com>
	<CAGXu5jL3GjrqsixS6U+GYD1pxAOOcXsXbt5XOVC8KhZB+naXAA@mail.gmail.com>
	<20140809030822.GA9422@gondor.apana.org.au>
Date: Tue, 12 Aug 2014 12:07:21 -0700
X-Google-Sender-Auth: 7HCqD3v-0iGfJFkxi9atIJ7nDQA
Message-ID: <CAGXu5jLMYKB3xmRd3qOZUSRoJwM7r-s3O+asECvLn4-vyjCKLA@mail.gmail.com>
Subject: Re: [PATCH] mm/zpool: use prefixed module loading
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Dan Streetman <ddstreet@ieee.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux-MM <linux-mm@kvack.org>, Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 8:08 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Aug 08, 2014 at 05:06:41PM -0700, Kees Cook wrote:
>>
>> I think we need to fix zswap now before it gets too far, and likely
>> adjust the crypto API to use a module prefix as well. Perhaps we need
>> a "crypto-" prefix?
>
> Yes I think a crypto- prefix would make sense.  Most crypto
> algorithms should be providing an alias already so it's mostly
> just changing the aliases.
>
> Patches are welcome :)

Okay, I'll see the zpool patch again with the aliases moved into the
ZPOOL ifdef, and I'll start working on a crypto patch set to solve the
prefix there too.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
