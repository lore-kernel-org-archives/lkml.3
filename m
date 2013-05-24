Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3EXKor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:44:47 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63063 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3EXKoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <1369381287-3923-1-git-send-email-jonas@southpole.se>
References: <1369381287-3923-1-git-send-email-jonas@southpole.se>
Date: Fri, 24 May 2013 12:44:45 +0200
X-Google-Sender-Auth: WwQ1rsdzl6zcdJDKi62z2syvqkU
Message-ID: <CAMuHMdUVd4QnLK69MWQe1xCEQAd8Qmbgycmu9P+o7+fUpvxTxQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] cris: remove unused current_regs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

On Fri, May 24, 2013 at 9:41 AM, Jonas Bonn <jonas@southpole.se> wrote:
> As your 'exotic' branch seems to show you're doing some work on CRIS, how
> about taking this rather trivial patch into your branch as well.  I sent
> this to the CRIS maintainers/mailing list six months ago but never got
> any response back.

It's queued on their cris/for-next branch, though.

> diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
> index c0a29b9..15b815d 100644
> --- a/arch/cris/include/asm/processor.h
> +++ b/arch/cris/include/asm/processor.h
> @@ -47,7 +47,6 @@ struct task_struct;
>   */
>
>  #define task_pt_regs(task) user_regs(task_thread_info(task))
> -#define current_regs() task_pt_regs(current)
>
>  unsigned long get_wchan(struct task_struct *p);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
