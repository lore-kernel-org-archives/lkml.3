Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3BEQeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:34:37 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:38137 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3BEQef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:34:35 -0500
MIME-Version: 1.0
In-Reply-To: <1359889813-10029-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1359889813-10029-1-git-send-email-maxime.ripard@free-electrons.com>
	<1359889813-10029-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Tue, 5 Feb 2013 17:34:34 +0100
Message-ID: <CACRpkdYcp5_BvTdSTgHg2xhmnsdx=oT=e19oJnFHCyMaMkGT5g@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: sunxi: Add of_xlate function
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 3, 2013 at 12:10 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Since the pin controller of sunxi chips is represented as a single bank
> in the driver.
> Since this is neither convenient nor represented that way in the
> datasheets, define a custom of_xlate function with the layout <bank pin
> flag>
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied to my allwinner branch. I will soon lock down this branch
and merge it into devel so I mature my devel branch for the
merge window.

Yours,
Linus Walleij
