Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaDWOL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:11:56 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:55129 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaDWOLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:11:54 -0400
MIME-Version: 1.0
In-Reply-To: <1398192025-31523-2-git-send-email-geert+renesas@glider.be>
References: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
	<1398192025-31523-2-git-send-email-geert+renesas@glider.be>
Date: Wed, 23 Apr 2014 16:11:54 +0200
Message-ID: <CACRpkdY4gASYR7CR64ux6QgMNdmmNYt86QQF7gvvTjK_6C7c8w@mail.gmail.com>
Subject: Re: [PATCH 2/4] dt: bindings: Typo s/interrupts-names/interrupt-names/g
From: Linus Walleij <linus.walleij@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Signed-off-by: Mark Brown" <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 8:40 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  .../devicetree/bindings/pinctrl/pinctrl-st.txt     |    4 ++--
>  .../bindings/sound/davinci-mcasp-audio.txt         |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Maybe Mark can apply this then, as it's mostly sound related.
Ideally it should be two patches but who cares about such a petty
detail.

Yours,
Linus Walleij
