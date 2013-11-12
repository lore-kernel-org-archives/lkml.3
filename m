Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3KLTw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:52:28 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63510 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab3KLTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <528286C2.70908@nod.at>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
	<1384285347-13506-18-git-send-email-geert@linux-m68k.org>
	<528286C2.70908@nod.at>
Date: Tue, 12 Nov 2013 20:52:20 +0100
X-Google-Sender-Auth: YrV955kRCW3yneGW5s0emAM2STY
Message-ID: <CAMuHMdWfvFt0PBxEzNXF1zRQ1Xed10yz4E44FNMhovOy-uu9Eg@mail.gmail.com>
Subject: Re: [PATCH 17/17] um: Remove unused declarations from <as-layout.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, Nov 12, 2013 at 8:51 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 12.11.2013 20:42, schrieb Geert Uytterhoeven:
>> _end is used, but it's already provided by <asm/sections.h>, so use that.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Richard Weinberger <richard@nod.at>
>> Cc: user-mode-linux-devel@lists.sourceforge.net
>
> Geert, do you want me to pickup this patch or takes Andrew the whole series?
>
> Acked-by: Richard Weinberger <richard@nod.at>

Feel free to pick it up. Less work for (overworked?) Andrew.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
