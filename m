Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab3FMNQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:16:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52393 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3FMNQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:16:32 -0400
MIME-Version: 1.0
In-Reply-To: <mvm7ghyrydr.fsf@hawking.suse.de>
References: <1371124784-13306-1-git-send-email-geert@linux-m68k.org>
	<mvm7ghyrydr.fsf@hawking.suse.de>
Date: Thu, 13 Jun 2013 15:16:32 +0200
X-Google-Sender-Auth: d0M3430dW_NJjOSvI0zD3cPfMKg
Message-ID: <CAMuHMdVdvHBzFbsNu96J+hXO-aVU8Z1XXVG_UtszJMdoz9nkMg@mail.gmail.com>
Subject: Re: [PATCH] m68k/uaccess: Fix asm constraints for userspace access
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 2:25 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> Also, relax the asm constraints for 16-bit userspace accesses in
>> __put_user() and __get_user(), as both "move" and "moves" do support
>> such transfers between memory and address registers.
>
> There's another occurrence in __constant_copy_from_user and
> __constant_copy_to_user.

Thanks! I will fix those, too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
