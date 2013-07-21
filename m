Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3GUP2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:28:17 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63580 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab3GUP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:28:14 -0400
MIME-Version: 1.0
In-Reply-To: <1373030792-28518-1-git-send-email-ldewangan@nvidia.com>
References: <1373030792-28518-1-git-send-email-ldewangan@nvidia.com>
Date: Sun, 21 Jul 2013 17:28:14 +0200
Message-ID: <CACRpkdby9yMPdJZ2oDcc3ju5gufED5R4mKmLXNNPfAhyvqT-6Q@mail.gmail.com>
Subject: Re: [PATCH V3] gpio: palmas: add dt support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        kishon@ti.com, j-keerthy@ti.com, Graeme Gregory <gg@slimlogic.co.uk>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 5, 2013 at 3:26 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Add of_device_id table for Palma GPIO to be enable the
> driver from DT file.
>
> The driver can be registered from DT file as:
>         palmas: tps65913@58 {
>                 :::::::::::
>                 palmas_gpio: palmas_gpio {
>                         compatible = "ti,palmas-gpio";
>                         gpio-controller;
>                         #gpio-cells = <2>;
>                 };
>         };
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Looks alright to me, but please resend this and include
devicetree@vger.kernel.org on the repost, this is where
DT bindings gets reviewed nowadays.

Yours,
Linus Walleij
