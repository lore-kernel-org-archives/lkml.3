Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaHYLgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:36:45 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34349 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaHYLgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1408242040020.2066@localhost6.localdomain6>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
	<1408818808-18850-7-git-send-email-Julia.Lawall@lip6.fr>
	<CAMuHMdVERt9XBN5OW8QqT_PvQVHd6xgnCdjRpiSNp7ZSEgXWSg@mail.gmail.com>
	<alpine.DEB.2.02.1408242040020.2066@localhost6.localdomain6>
Date: Mon, 25 Aug 2014 13:36:41 +0200
X-Google-Sender-Auth: LanquFRkfpuANpIQb58xizkNTlM
Message-ID: <CAMuHMdXuL_0ZAXC-hDZ7bm8xxXYpU5cU9d11D2PG-7e_VA584Q@mail.gmail.com>
Subject: Re: [PATCH 6/7] video: fbdev: sis: delete double assignment
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Thomas Winischhofer <thomas@winischhofer.net>,
        Joe Perches <joe@perches.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sun, Aug 24, 2014 at 8:40 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>> On Sat, Aug 23, 2014 at 8:33 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>> > ---
>> > The patches in this series do not depend on each other.
>> >
>> > This changes the semantics of the code and is not tested.
>>
>> Hence I think you should change the subject of the patch, so it's obvious
>> some bug is fixed, e.g. "video: fbdev: sis: Fix double assignment".
>
> Do you want me to resend this patch with the new subject, or just keep it
> in mind for the future?

That's up to the fbdev maintainer.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
