Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaHYRKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:10:20 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50968 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaHYRKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:10:18 -0400
MIME-Version: 1.0
In-Reply-To: <53FB6B26.3030906@infradead.org>
References: <1408956471-16579-1-git-send-email-geert+renesas@glider.be>
	<53FB6B26.3030906@infradead.org>
Date: Mon, 25 Aug 2014 19:10:17 +0200
X-Google-Sender-Auth: gg28m6rq9rIDYSQ2OMrcmCvTNQY
Message-ID: <CAMuHMdXOf8L5QpLdtpxkW1x7iA1hCGMuK+h_7NsKS0VvZDy6Mw@mail.gmail.com>
Subject: Re: [PATCH] regulator: Proofread documentation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Mon, Aug 25, 2014 at 6:58 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> -The load_uA value can be determined from the consumers datasheet. e.g.most
>> -datasheets have tables showing the max current consumed in certain situations.
>> +The load_uA value can be determined from the consumer's datasheet. e.g. most
>
> Prefer:                                                               E.g.

Me too. But the regulator docs consistently use full stops followed by
lower-case abbreviations everywhere, so I kept them.

> otherwise,
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
