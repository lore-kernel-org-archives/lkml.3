Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3HUVpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:45:03 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40528 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3HUVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <1375609657-15434-8-git-send-email-maxime.ripard@free-electrons.com>
References: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
	<1375609657-15434-8-git-send-email-maxime.ripard@free-electrons.com>
Date: Wed, 21 Aug 2013 23:45:01 +0200
Message-ID: <CACRpkdbGPVzEtLWLDQgqKMz-XkuCQW4yKyK1XySuU+thQVS2RQ@mail.gmail.com>
Subject: Re: [PATCHv3 07/10] pinctrl: sunxi: Add Allwinner A31 pins set
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

On Sun, Aug 4, 2013 at 11:47 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The Allwinner A31 SoC uses the same IP than the one found in the
> A10/A13, with only different pins. Add the pins and the associated
> functions found in the A31.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Do you want me to apply this to the pinctrl tree?

Yours,
Linus Walleij
