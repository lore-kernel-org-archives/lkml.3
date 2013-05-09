Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3EILJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:09:20 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:54392 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3EILJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:09:18 -0400
MIME-Version: 1.0
In-Reply-To: <1368095819-11011-7-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
	<1368095819-11011-7-git-send-email-yefremov.denis@gmail.com>
Date: Thu, 9 May 2013 13:09:18 +0200
X-Google-Sender-Auth: DwRMshReVWZo-kVQQsQL96-RV3U
Message-ID: <CAMuHMdX9BiVKHm3ZdMjP1H0DVtGacAahztr+Rn+3epse8EWXZA@mail.gmail.com>
Subject: Re: [PATCH 18/21] m68k/sun3/: remove inline marking of EXPORT_SYMBOL functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Sam Creasey <sammy@sammy.net>, linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>, ldv-project@linuxtesting.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 12:36 PM, Denis Efremov <yefremov.denis@gmail.com> wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Do you want me to queue this in the m68k tree?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
