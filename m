Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3KTIvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:51:47 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47850 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTIvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:51:45 -0500
MIME-Version: 1.0
In-Reply-To: <1384934391.56931.YahooMailNeo@web163904.mail.gq1.yahoo.com>
References: <1384934391.56931.YahooMailNeo@web163904.mail.gq1.yahoo.com>
Date: Wed, 20 Nov 2013 09:51:44 +0100
X-Google-Sender-Auth: fIiBeS5S2i4forCEGMGySx2q80U
Message-ID: <CAMuHMdW-j=FOAo9ZAFFJBiFqBn111Ebng6wTM-t7a3fGhjXsDg@mail.gmail.com>
Subject: Re: Having troubles in updating MTD partitions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Suki Buryani <sukiburyani@yahoo.com>
Cc: "uclinux-dev@uclinux.org" <uclinux-dev@uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 8:59 AM, Suki Buryani <sukiburyani@yahoo.com> wrote:
>   31     3       5884 mtdblock3

5884 is the raw size of mtdblock3.

>  but when i try to use memory relevant tools, it shows me something like
>  # df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/root                 5824      5824         0 100% /

5824 is the usable size of the file system on mtdblock3, i.e. after subtracting
the overhead for file system bookkeeping.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
