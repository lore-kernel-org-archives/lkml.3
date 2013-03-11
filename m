Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3CKV5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:57:22 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40891 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3CKV5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1303112254140.16847@ayla.of.borg>
References: <alpine.DEB.2.00.1303112254140.16847@ayla.of.borg>
Date: Mon, 11 Mar 2013 22:57:21 +0100
X-Google-Sender-Auth: 5Azg3M302zDuTAp0kNccSAwkIsI
Message-ID: <CAMuHMdXZOJ+kOsz8XdZTYF2ARUQE=HTkMrCyO4Jp6SonRT4FSg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.9-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:54 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.9-rc2 to v3.9-rc1[3], the summaries are:
>   - build errors: +1/-0

Which is a false positive, due to the interspersion of make -j output.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
