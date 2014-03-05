Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaCEC2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:28:03 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52864 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbaCEC2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:28:00 -0500
MIME-Version: 1.0
In-Reply-To: <1393970762-5346-1-git-send-email-holler@ahsoftware.de>
References: <5315ED51.1000006@ti.com>
	<1393970762-5346-1-git-send-email-holler@ahsoftware.de>
Date: Wed, 5 Mar 2014 10:27:59 +0800
Message-ID: <CACRpkdb2ECPyTcGkt7XcBt9HP1335xXHjxKZpYR4Dd3K+YmDYQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: davinci: fix gpio selection for OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexander Holler <holler@ahsoftware.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        KV Sujith <sujithkv@ti.com>, Sekhar Nori <nsekhar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 6:06 AM, Alexander Holler <holler@ahsoftware.de> wrote:

> The driver missed an of_xlate function to translate gpio numbers
> as found in the DT to the correct chip and number.
>
> While there I've set #gpio_cells to a fixed value of 2.
>
> I've used gpio-pxa.c as template for those changes and tested my changes
> successfully on a da850 board using entries for gpio-leds in a DT. So I didn't
> reinvent the wheel but just copied and tested stuff.
>
> Thanks to Grygorii Strashko for the hint of the existing code in gpio-pxa.
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

Grygorii, can I have your review tag on this patch so I can apply it?

Yours,
Linus Walleij
