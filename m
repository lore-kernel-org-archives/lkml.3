Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3LCJEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:04:47 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62749 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3LCJE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:04:28 -0500
MIME-Version: 1.0
In-Reply-To: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
Date: Tue, 3 Dec 2013 10:04:25 +0100
X-Google-Sender-Auth: bWfI-2ZXKR-NlglIxYTmsPwmD2k
Message-ID: <CAMuHMdXcHTTmnqCTJWRJU_2vgv3wtB9gFGiR5Z0GF=BDKniXCg@mail.gmail.com>
Subject: Re: [PATCH] Remove unnecessarily gendered language
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disclaimer: didn't read through all of it.

On Tue, Dec 3, 2013 at 2:18 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> --- a/drivers/scsi/mesh.c
> +++ b/drivers/scsi/mesh.c
> @@ -1190,8 +1190,8 @@ static void handle_msgin(struct mesh_state *ms)
>                         if (tp->sdtr_state != sdtr_sent) {
>                                 /* reply with an SDTR */
>                                 add_sdtr_msg(ms);
> -                               /* limit period to at least his value,
> -                                  offset to no more than his */
> +                               /* limit period to at least its value,
> +                                  offset to no more than its */
>                                 if (ms->msgout[3] < ms->msgin[3])
>                                         ms->msgout[3] = ms->msgin[3];
>                                 if (ms->msgout[4] > ms->msgin[4])

I think both occurrences of "his" should actually be "this".

BTW, the singular they  ("The caller must know what they are doing!")
feels a bit strange to me, but it seems to match the wikipedia article on
singular they. As a non-native English speaker, I was not familiar with it.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
