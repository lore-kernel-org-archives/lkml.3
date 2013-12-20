Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3LTJkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:40:33 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58023 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3LTJk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com>
References: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com>
Date: Fri, 20 Dec 2013 10:40:29 +0100
Message-ID: <CACRpkdYcvtWNgJ=JCgpZFdZmypLu7UmtpyTQusRshSGT=EqsVg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] gpio: davinci: reuse for keystone arch
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:07 AM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> This series is intended to update Davinci GPIO driver and reuse
> it for Keystone SoCs, because Keystone uses the similar GPIO IP like Davinci.
> Keystone GPIO IP: supports:
> - up to 32 GPIO lines;
> - only unbanked irqs;
>
> See Documentation:
> Keystone - http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>
> This series based on:
> https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git/log/?h=v3.14/gpio
>
> Changes in v2:
> - minor comments applied, no functional changes
>
> v1: https://lkml.org/lkml/2013/12/12/366

Acked-by: Linus Walleij <linus.walleij@linaro.org>

For this v2 series.

Expecting this to go in through the DaVinci tree!

Yours,
Linus Walleij
