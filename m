Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaJ0QWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:22:20 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60134 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJ0QWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <1412823327-10296-4-git-send-email-blogic@openwrt.org>
References: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
	<1412823327-10296-4-git-send-email-blogic@openwrt.org>
Date: Mon, 27 Oct 2014 17:22:18 +0100
Message-ID: <CACRpkdbq3u-PoPiN5patknfv5o1-XrVYkGbwTGRCsYpXuuOiGA@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: ralink: add binding documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 4:55 AM, John Crispin <blogic@openwrt.org> wrote:

> Signed-off-by: John Crispin <blogic@openwrt.org>

This does not seem complete since it lacks things like the very
controversial gpio-base thing.

> +++ b/Documentation/devicetree/bindings/pinctrl/ralink,rt2880-pinmux.txt
> @@ -0,0 +1,74 @@
> +Ralink rt2880 pinmux controller
> +
> +Required properties:
> +- compatible: "lantiq,rt2880-pinmux"
> +- reg: Should contain the physical address and length of the gpio/pinmux
> +  register range
> +
> +The rt2880 pinmux can only set the muxing of pin groups. muxing indiviual pins
> +is not supported. There is no pinconf support.
> +
> +Definition of mux function groups:
> +
> +Required subnode-properties:
> +- ralink,group : An array of strings. Each string contains the name of a group.
> +  Valid values for these names are listed below.
> +- ralink,function: A string containing the name of the function to mux to the
> +  group. Valid values for function names are listed below.

Just use "function" and "group" from the generic bindings.

Yours,
Linus Walleij
