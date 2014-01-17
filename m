Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaAQObo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:31:44 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:53859 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaAQObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:31:41 -0500
MIME-Version: 1.0
In-Reply-To: <1389869055-9467-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1389869055-9467-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Fri, 17 Jan 2014 15:31:39 +0100
Message-ID: <CACRpkdYuyLc76Md9=WOsNCssjLs8b+FGX-nxhheR=6jHcWnkgw@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: mcp23s08: Add irq functionality for i2c chips
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: Lars Poeschel <poeschel@lemonage.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 11:44 AM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> From: Lars Poeschel <poeschel@lemonage.de>
>
> This adds interrupt functionality for i2c chips to the driver.
> They can act as a interrupt-controller and generate interrupts, if
> the inputs change.
> This is tested with a mcp23017 chip on an arm based platform.
>
> v3:

It's beautiful. Patch applied.

Yours,
Linus Walleij
