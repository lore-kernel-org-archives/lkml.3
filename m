Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaIWJ7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:59:34 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60010 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaIWJ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <00b4375542ac3698ed59d3ea353cc14e1c00a5bc.1410020459.git.stefan@agner.ch>
References: <cover.1410020458.git.stefan@agner.ch>
	<00b4375542ac3698ed59d3ea353cc14e1c00a5bc.1410020459.git.stefan@agner.ch>
Date: Tue, 23 Sep 2014 11:59:32 +0200
Message-ID: <CACRpkdZcp7r3XPFDqWZ-owLNhn491wzMzBjGAHi79ozzePU+UQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: dts: vf610: Use new GPIO support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 6:25 PM, Stefan Agner <stefan@agner.ch> wrote:

> Use GPIO support by adding SD card detection configuration and
> GPIO pinmux for Colibri's standard GPIO pins.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess you need the rest to be merged first though?

Yours,
Linus Walleij
