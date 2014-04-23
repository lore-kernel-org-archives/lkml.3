Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaDWRfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:35:06 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37813 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaDWRfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:35:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdY4gASYR7CR64ux6QgMNdmmNYt86QQF7gvvTjK_6C7c8w@mail.gmail.com>
References: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
	<1398192025-31523-2-git-send-email-geert+renesas@glider.be>
	<CACRpkdY4gASYR7CR64ux6QgMNdmmNYt86QQF7gvvTjK_6C7c8w@mail.gmail.com>
Date: Wed, 23 Apr 2014 19:35:00 +0200
X-Google-Sender-Auth: 0De1IqIMLhODjq67WhSBsSZjHNk
Message-ID: <CAMuHMdXO1u_Aw5BM7+a6TNM5+Rt-FCgnFLsGn9-w-nv=AKaaiQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] dt: bindings: Typo s/interrupts-names/interrupt-names/g
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Signed-off-by: Mark Brown" <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Apr 23, 2014 at 4:11 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Apr 22, 2014 at 8:40 PM, Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Signed-off-by: Mark Brown <broonie@linaro.org>
>> ---
>>  .../devicetree/bindings/pinctrl/pinctrl-st.txt     |    4 ++--
>>  .../bindings/sound/davinci-mcasp-audio.txt         |    2 +-
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks!

> Maybe Mark can apply this then, as it's mostly sound related.
> Ideally it should be two patches but who cares about such a petty
> detail.

Opinions about patch granularity differ...
Grant Likely replied to one of the other patches in the series:

| Applied all, but squashed into a single patch. I'll send it up to Linus
| as a fix for 3.15

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
