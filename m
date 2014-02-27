Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaB0Vw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:52:29 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50088 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaB0Vw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:52:27 -0500
MIME-Version: 1.0
In-Reply-To: <1393508474-16710-1-git-send-email-geert@linux-m68k.org>
References: <1393508474-16710-1-git-send-email-geert@linux-m68k.org>
Date: Fri, 28 Feb 2014 01:52:26 +0400
Message-ID: <CAMo8BfLwxUMRLxCYxeHG97C6jESowr8_jVwQHF7x467PmWY6Ag@mail.gmail.com>
Subject: Re: [PATCH -next] xtensa: Export __invalidate_icache_range
From: Max Filippov <jcmvbkbc@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>, Kees Cook <keescook@chromium.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 5:41 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> When modular code calls flush_icache_range():
>
>     ERROR: "__invalidate_icache_range" [drivers/misc/lkdtm.ko] undefined!
>     make[1]: *** [__modpost] Error 1
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/10663772/
>
>  arch/xtensa/kernel/xtensa_ksyms.c |    1 +
>  1 file changed, 1 insertion(+)

Thanks, applied to my xtensa tree.

-- Max
