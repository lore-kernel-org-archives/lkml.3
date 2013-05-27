Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3E0KlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:41:07 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41393 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab3E0KlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:41:05 -0400
MIME-Version: 1.0
In-Reply-To: <1369232581-18923-8-git-send-email-lee.jones@linaro.org>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
	<1369232581-18923-8-git-send-email-lee.jones@linaro.org>
Date: Mon, 27 May 2013 12:41:04 +0200
Message-ID: <CACRpkdYyZZSy4VgFc+Uo=5iAF++EPmHM0U2pHcLdkDZc=Xb_sQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] Documentation: Update binding for Nomadik and DBx5x
 based platforms
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 4:23 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Change compatible string to something more standard.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> index 9a2f3f4..c3d8a89 100644
> --- a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> @@ -1,8 +1,8 @@
>  ST Ericsson Nomadik pinmux controller
>
>  Required properties:
> -- compatible: "stericsson,nmk-pinctrl", "stericsson,nmk-pinctrl-db8540",
> -              "stericsson,nmk-pinctrl-stn8815"
> +- compatible: "stericsson,db8500-pinctrl", "stericsson,db8540-pinctrl",
> +              "stericsson,stn8815-pinctrl"

OK...

>         pinctrl@80157000 {
> -               compatible = "stericsson,nmk-pinctrl";
> +               compatible = "stericsson,u8500-pinctrl";

This does not look like a supported compatible string?

Yours,
Linus Walleij
