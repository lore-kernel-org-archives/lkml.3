Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3HUVqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:46:54 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40796 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3HUVqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:46:53 -0400
MIME-Version: 1.0
In-Reply-To: <1375610330-18185-5-git-send-email-maxime.ripard@free-electrons.com>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
	<1375610330-18185-5-git-send-email-maxime.ripard@free-electrons.com>
Date: Wed, 21 Aug 2013 23:46:53 +0200
Message-ID: <CACRpkdb8=wi4qQeNcnsvAZMUf0ja2t5rn9b=EeWSBc4fJ1+Wig@mail.gmail.com>
Subject: Re: [PATCHv3 4/9] pinctrl: sunxi: Add Allwinner A20 pins set
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 11:58 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The Allwinner A20 is pin-compatible with the older A10, so the two pin
> set are quite similar. However, since the A20 has new features, we can't
> just use the A10 pin set as is, and we need to define our own for the
> A20.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Shall I apply this to the pinctrl tree?

Yours,
Linus Walleij
