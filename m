Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbbAGJ4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:56:36 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37556 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbAGJ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:56:02 -0500
MIME-Version: 1.0
In-Reply-To: <1420558883-10131-37-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
	<1420558883-10131-37-git-send-email-mst@redhat.com>
Date: Wed, 7 Jan 2015 10:56:00 +0100
X-Google-Sender-Auth: BefAkVAV-g_jAra0-r5leJ-7ptk
Message-ID: <CAMuHMdXsBsdUH-C2rHTDf4csYsNjsx2_nn4jfNEgm-akduSUAw@mail.gmail.com>
Subject: Re: [PATCH v2 36/40] m68k: macro whitespace fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 4:45 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> While working on arch/m68k/include/asm/uaccess.h, I noticed
> that one macro within this header is made harder to read because it
> violates a coding style rule: space is missing after comma.
>
> Fix it up.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
