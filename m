Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3FGSbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:31:10 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47268 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab3FGSbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:31:07 -0400
MIME-Version: 1.0
In-Reply-To: <1370568312.2209.76.camel@joe-AO722>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
	<1370551945-8444-5-git-send-email-keescook@chromium.org>
	<20130607003914.GH7052@lizard.sbx05280.losalca.wayport.net>
	<1370568312.2209.76.camel@joe-AO722>
Date: Fri, 7 Jun 2013 11:31:06 -0700
X-Google-Sender-Auth: VjsOMEGJ1MorzkVQMsdWECm-NIE
Message-ID: <CAGXu5j+YwLHzETz4kkSFU0bJRWgR44qtypc8vDGJX5tvhm1khw@mail.gmail.com>
Subject: Re: [PATCH] power: Add missing newlines, fix a couple of typos, add pr_fmt
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Anton Vorontsov <anton@enomsg.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 6:25 PM, Joe Perches <joe@perches.com> wrote:
> Make sure that dev_<level> calls are newline terminated.
> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt to prefix
> all pr_<level> calls with "charger-manager: "
>
> Fix a couple of typos.
> Fix formats with terminating n that should be \n.
> Coalesce formats for easier grep.
> Align arguments to open parenthesis for these dev_<level> calls.
> Add missing spaces after coalescing multiple string segments.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Looks like good clean-ups.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

--
Kees Cook
Chrome OS Security
