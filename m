Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaJ1OVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:21:15 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58064 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaJ1OVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <1413321714-25931-3-git-send-email-b.galvani@gmail.com>
References: <1413321714-25931-1-git-send-email-b.galvani@gmail.com>
	<1413321714-25931-3-git-send-email-b.galvani@gmail.com>
Date: Tue, 28 Oct 2014 15:21:09 +0100
Message-ID: <CACRpkdbw-Rdm9PoOfbmLApJX-df5Kcmag4a=GHV58Y7T=1ykQg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] pinctrl: meson: add device tree bindings documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Carlo Caione <carlo@caione.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 11:21 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:

> Add device tree bindings documentation for Amlogic Meson pinmux and
> GPIO controller.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
(...)

> +               gpio_ao: ao-bank@c1108030 {
> +                       reg = <0xc8100014 0x4>,
> +                             <0xc810002c 0x4>,
> +                             <0xc8100024 0x8>;

This still has the same problem as in the previous review.

It seems for both patches you posted v2 before I got to review
v1, so sorry for the confusion.

Please take the combined result of my review letters and
fix everything...

Yours,
Linus Walleij
