Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3G2QUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:20:15 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:60562 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3G2QUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:20:13 -0400
MIME-Version: 1.0
In-Reply-To: <1374618312-19001-8-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
	<1374618312-19001-8-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 29 Jul 2013 18:20:13 +0200
Message-ID: <CACRpkdZ1RhsLMC0xWDDr9Hmy78i+uU-9x0-2Y+_NvRZ-yefmVw@mail.gmail.com>
Subject: Re: [PATCH 07/10] pinctrl: sunxi: Add Allwinner A31 pins set
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Albert ARIBAUD <albert.u.boot@aribaud.net>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:25 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The Allwinner A31 SoC uses the same IP than the one found in the
> A10/A13, with only different pins. Add the pins and the associated
> functions found in the A31.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Will you carry this through ARM SoC or do you want me to merge
this into the pinctrl tree? It seems pretty independent.

Yours,
Linus Walleij
