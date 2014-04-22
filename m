Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaDVLnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:43:08 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53353 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaDVLnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:43:03 -0400
MIME-Version: 1.0
In-Reply-To: <1397137966-30818-5-git-send-email-boris.brezillon@free-electrons.com>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
	<1397137966-30818-5-git-send-email-boris.brezillon@free-electrons.com>
Date: Tue, 22 Apr 2014 13:43:03 +0200
Message-ID: <CACRpkdZLkDM68uRAKH1c2UeAL5isDEK8eFqpEw63K2TxNOPxeQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] pinctrl: sunxi: support multiple pin controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dev@linux-sunxi.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 3:52 PM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:

> Add support for multiple pin controller instances.
>
> First remove the static definition of the sunxi gpio chip struct and fill
> the dynamically struct instead.
> Then define a new pin_base field in the sunxi_pinctrl_desc which will be
> used to specify the gpiochip base pin.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied.

Yours,
Linus Walleij
