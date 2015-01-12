Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbbALSCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:02:12 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:42769 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbALSCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:02:10 -0500
MIME-Version: 1.0
In-Reply-To: <1421076472-7101-1-git-send-email-colin.king@canonical.com>
References: <1421076472-7101-1-git-send-email-colin.king@canonical.com>
Date: Mon, 12 Jan 2015 19:02:08 +0100
X-Google-Sender-Auth: 3Cv5kj1dP8szEtxD6EXeEnuwYQs
Message-ID: <CAMuHMdXXRpFM2VkEz6gGMA5tmXEKt0mpfUMbgM=SPBZgwVg3Eg@mail.gmail.com>
Subject: Re: [PATCH][RESEND] static code analysis from cppcheck reports:
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Colin King <colin.king@canonical.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 4:27 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> [drivers/video/fbdev/broadsheetfb.c:673]:
>   (error) Memory leak: sector_buffer
>
> sector_buffer is not being kfree'd on each call to
> broadsheet_spiflash_rewrite_sector(), so free it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

So you can make the box go OOM by repeatedly writing to the
loadstore_waveform device attribute file?
Do we want this applied to -stable?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
