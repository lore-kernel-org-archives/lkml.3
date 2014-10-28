Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaJ1RC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:02:26 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35116 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaJ1RCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <20141023132305.GG14443@pengutronix.de>
References: <20141023132305.GG14443@pengutronix.de>
Date: Tue, 28 Oct 2014 18:02:23 +0100
Message-ID: <CACRpkdb+p5tyyZvARLA5R6oayezJNemLzYDjT-jzrtoPqW2qsA@mail.gmail.com>
Subject: Re: [RFC] pinctrl: Provide a generic device tree binding for per-pin
 pin controllers
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 3:23 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Most iomux controllers allow a configuration per pin. These currently
> have no common device tree binding. There are many different SoC
> specific bindings for this class of iomux controllers. Some controllers
> artificially group pins together where in hardware no groups exist (for
> example lantiq). Other controllers just put each pin into a separate
> group which explodes to many many strings to parse (Tegra30).

So I'd specifically like Stephen Warrens comments on this proposal,
as well as from everyone else doing per-pin device tree configs.

Yours,
Linus Walleij
