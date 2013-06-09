Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036Ab3FIRKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:10:52 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43378 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3FIRKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:10:50 -0400
Date: Sun, 9 Jun 2013 10:10:48 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>, "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] power: Add missing newlines, fix a couple of typos, add
 pr_fmt
Message-ID: <20130609171047.GB23128@teo>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
 <1370551945-8444-5-git-send-email-keescook@chromium.org>
 <20130607003914.GH7052@lizard.sbx05280.losalca.wayport.net>
 <1370568312.2209.76.camel@joe-AO722>
 <CAGXu5j+YwLHzETz4kkSFU0bJRWgR44qtypc8vDGJX5tvhm1khw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5j+YwLHzETz4kkSFU0bJRWgR44qtypc8vDGJX5tvhm1khw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:31:06AM -0700, Kees Cook wrote:
> On Thu, Jun 6, 2013 at 6:25 PM, Joe Perches <joe@perches.com> wrote:
> > Make sure that dev_<level> calls are newline terminated.
> > Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt to prefix
> > all pr_<level> calls with "charger-manager: "
> >
> > Fix a couple of typos.
> > Fix formats with terminating n that should be \n.
> > Coalesce formats for easier grep.
> > Align arguments to open parenthesis for these dev_<level> calls.
> > Add missing spaces after coalescing multiple string segments.
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Looks like good clean-ups.
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Applied, thanks!

Anton
