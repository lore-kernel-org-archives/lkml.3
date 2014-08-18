Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaHRQWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:22:06 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65263 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaHRQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:22:04 -0400
MIME-Version: 1.0
In-Reply-To: <1408377559-30775-1-git-send-email-bobby.prani@gmail.com>
References: <1408377559-30775-1-git-send-email-bobby.prani@gmail.com>
Date: Mon, 18 Aug 2014 20:22:02 +0400
Message-ID: <CAMo8BfKshP0KT=D8dWzDfbGSfEpd_SeQPRboGGN9b8B4btRBtQ@mail.gmail.com>
Subject: Re: [PATCH v2] flush_icache_range: Export symbol to fix build errors
From: Max Filippov <jcmvbkbc@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>, Richard Kuo <rkuo@codeaurora.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        Noam Camus <noamc@ezchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tony Lu <zlu@tilera.com>, Kirill Tkhai <tkhai@yandex.ru>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QUALCOMM HEXAGON..." <linux-hexagon@vger.kernel.org>,
        "open list:SUPERH" <linux-sh@vger.kernel.org>,
        "open list:TENSILICA XTENSA..." <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 7:59 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Fix building errors occuring due to a missing export of flush_icache_range() in
>
> kisskb.ellerman.id.au/kisskb/buildresult/11677809/
>
> ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/arc/mm/cache_arc700.c | 1 +
>  arch/hexagon/mm/cache.c    | 1 +
>  arch/sh/mm/cache.c         | 1 +
>  arch/tile/kernel/smp.c     | 1 +
>  arch/xtensa/kernel/smp.c   | 1 +
>  5 files changed, 5 insertions(+)

For xtensa
Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
