Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaAOH55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:57:57 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53250 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaAOH5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:57:55 -0500
MIME-Version: 1.0
In-Reply-To: <1389333783-3372-1-git-send-email-zhangwm@marvell.com>
References: <1389333783-3372-1-git-send-email-zhangwm@marvell.com>
Date: Wed, 15 Jan 2014 08:57:54 +0100
Message-ID: <CACRpkda=4AhOWDYu7ENcovTo_+oSKKVU+eqkHD9W-3bDMv2MUQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: pxa: normalize the return value for gpio_get
From: Linus Walleij <linus.walleij@linaro.org>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 7:03 AM, Neil Zhang <zhangwm@marvell.com> wrote:

> It would be convenient to normalize the return value for gpio_get.
>
> I have checked mach-mmp / mach-pxa / plat-pxa / plat-orion / mach-orion5x.
> It's OK for all of them to change this function to return 0 and 1.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>

Bah I updated the commit message a bit ... you dropped the
gpio: pxa: etc from the previous patch, not good but don't worry
I fixed it up.

Yours,
Linus Walleij
