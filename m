Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbbA1Uzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:55:33 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35835 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbbA1Uz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:55:27 -0500
MIME-Version: 1.0
In-Reply-To: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com>
References: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com>
Date: Wed, 28 Jan 2015 18:55:25 -0200
Message-ID: <CAOMZO5CQVHD2bJbh4whmd7yxq0Mia7Gr+53W7z5pE+GrAkszgw@mail.gmail.com>
Subject: Re: [PATCH V2] clk: mxs: Fix invalid 32-bit access to frac registers
From: Fabio Estevam <festevam@gmail.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Mike Turquette <mturquette@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>, harald@ccbib.org,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Sun, Dec 28, 2014 at 8:26 AM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> According to i.MX23 and i.MX28 reference manual the fractional
> clock control registers must be addressed by byte instructions.
>
> This patch fixes the erroneous 32-bit access to these registers
> and extends the comment in the init functions.
>
> Btw the imx23 init now uses a R-M-W sequence just like imx28 init
> to avoid any clock glitches.
>
> The changes has been tested only with a i.MX28 board, because i don't
> have access to an i.MX23 board.

As you recently had a chance to test it on mx23, maybe you could
resend it and change this last parapgraph.

Regards,

Fabio Estevam
