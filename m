Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3H1LUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:20:31 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39608 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3H1LUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <1377244140.24387.1.camel@phoenix>
References: <1377244140.24387.1.camel@phoenix>
Date: Wed, 28 Aug 2013 13:20:30 +0200
Message-ID: <CACRpkdZr8ZU50t1RevdYRsyrEcr_UtD7GMCLk0nvjdp5p4y6nw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rockchip: Simplify pin_to_bank equation
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 9:49 AM, Axel Lin <axel.lin@ingics.com> wrote:

> If (b->pin_base + b->nr_pins - 1) < pin is true, pin >= b->pin_base is always
> true because b->nr_pins is never less than 0.
> Thus this patch simplify the equation.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied with Heiko's ACK.

Yours,
Linus Walleij
