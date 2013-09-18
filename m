Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3IRLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:16:29 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:43934 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3IRLQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:16:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130917190732.GD15645@radagast>
References: <20130917190732.GD15645@radagast>
Date: Wed, 18 Sep 2013 13:16:27 +0200
Message-ID: <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com>
Subject: Re: PCF857x and 16-bit GPIO expanders
From: Linus Walleij <linus.walleij@linaro.org>
To: Felipe Balbi <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 9:07 PM, Felipe Balbi <balbi@ti.com> wrote:

> has anyone ever successfully using gpio-pcf857x.c driver with 16-bit
> gpio expanders ? We're having some issues here where toggling the last
> gpio pin (gpio 15) on a PCF8575 device causes platform to hang and I
> can't come up with any explanation of why would it hang...

Bouncing the question to George, Laurent and Kuninori...

Yours,
Linus Walleij
