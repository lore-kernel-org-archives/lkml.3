Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaIXJQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:16:50 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35952 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaIXJQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:16:45 -0400
MIME-Version: 1.0
In-Reply-To: <2ca1cf3732a00512fa19b6118f9fb30aba014deb.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
	<2ca1cf3732a00512fa19b6118f9fb30aba014deb.1411404079.git.stefan@agner.ch>
Date: Wed, 24 Sep 2014 11:16:44 +0200
Message-ID: <CACRpkdbryJVW9e9N5+f3rWEGZ2YvLPJsvBtNSa9nPJpLVXhm0g@mail.gmail.com>
Subject: Re: [PATCH 1/9] ARM: dts: vf610: Add system reset controller (SRC)
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        jingchang.lu@freescale.com,
        Huang Yongcai-B20788 <b20788@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 7:09 PM, Stefan Agner <stefan@agner.ch> wrote:

> Add device tree property for system reset controller.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Are there already device tree bindings for SRC and GRC?

Yours,
Linus Walleij
