Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaHIDIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 23:08:48 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:52191 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaHIDIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 23:08:47 -0400
Date: Sat, 9 Aug 2014 11:08:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kees Cook <keescook@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux-MM <linux-mm@kvack.org>, Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] mm/zpool: use prefixed module loading
Message-ID: <20140809030822.GA9422@gondor.apana.org.au>
References: <20140808075316.GA21919@www.outflux.net>
 <CALZtONBNEg7kzUtwKihQuAU48MNh5NjhZcWoOxe-1-vgWqSLiw@mail.gmail.com>
 <CAGXu5jL3GjrqsixS6U+GYD1pxAOOcXsXbt5XOVC8KhZB+naXAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL3GjrqsixS6U+GYD1pxAOOcXsXbt5XOVC8KhZB+naXAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 05:06:41PM -0700, Kees Cook wrote:
>
> I think we need to fix zswap now before it gets too far, and likely
> adjust the crypto API to use a module prefix as well. Perhaps we need
> a "crypto-" prefix?

Yes I think a crypto- prefix would make sense.  Most crypto
algorithms should be providing an alias already so it's mostly
just changing the aliases.

Patches are welcome :)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
