Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3EULbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:31:39 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:43639 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3EULbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:31:38 -0400
MIME-Version: 1.0
In-Reply-To: <1368943117.3455.4.camel@phoenix>
References: <1368943117.3455.4.camel@phoenix>
Date: Tue, 21 May 2013 13:31:38 +0200
Message-ID: <CACRpkdbXDNY=SLcjfXTaR+8w7-qfHzP1PgqxvtvqhotA+=7bwg@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: Don't override the error code in probe error handling
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 7:58 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Otherwise, we return 0 in probe error paths when gpiochip_remove() returns 0.
> Also show error message if gpiochip_remove() fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Tony Prisk <linux@prisktech.co.nz>

Patch applied for fixes, with ACKs.

Yours,
Linus Walleij
