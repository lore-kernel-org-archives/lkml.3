Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbaIIMbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:31:23 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:42482 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaIIMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:31:22 -0400
MIME-Version: 1.0
In-Reply-To: <1410264760-29756-1-git-send-email-daniel.thompson@linaro.org>
References: <1410264760-29756-1-git-send-email-daniel.thompson@linaro.org>
Date: Tue, 9 Sep 2014 14:31:20 +0200
X-Google-Sender-Auth: vzZM9ZxOIkMieO5Dh9hNLiGMzKI
Message-ID: <CAMuHMdWvyfPxHKWD3MkgDQRaf4xQUzVq561C1BHiNC_stQ-Rqw@mail.gmail.com>
Subject: Re: [PATCH] asm-generic/io.h: Implement read[bwlq]_relaxed()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Sep 9, 2014 at 2:12 PM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> Currently the read[bwlq]_relaxed() family are implemented on every
> architecture except blackfin, m68k[1], metag, openrisc, s390[2] and
> score. Increasingly drivers are being optimized to exploit relaxed
> reads putting these architectures at risk of compilation failures for
> shared drivers.
>
> This patch addresses this by providing implementations of
> read[bwlq]_relaxed() that are identical to the equivalent read[bwlq]().
> All the above architectures include asm-generic/io.h .

m68k does not include asm-generic/io.h.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
