Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3JHMQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:16:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44873 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3JHMQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:16:30 -0400
MIME-Version: 1.0
In-Reply-To: <1380729030-25896-3-git-send-email-ldewangan@nvidia.com>
References: <1380729030-25896-1-git-send-email-ldewangan@nvidia.com>
	<1380729030-25896-3-git-send-email-ldewangan@nvidia.com>
Date: Tue, 8 Oct 2013 14:16:29 +0200
Message-ID: <CACRpkdbmAnRxDpP17tmAAeC7U6Yibd5N7vFA1o1h=4DdhW+H-g@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH V5 2/3] pincntrl: add support for ams AS3722
 pin control driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 5:50 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The AS3722 is a compact system PMU suitable for mobile phones, tablets etc.
>
> Add a driver to support accessing the GPIO, pinmux and pin configuration
> of 8 GPIO pins found on the ams AS3722 through pin control driver and
> gpiolib.
>
> The driver will register itself as the pincontrol driver and gpio driver.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Nit cleanups in driver and use module_platform_driver.
>
> Changes from V2:
> - Move the gpio driver from gpio folder to pinctnrl driver and register
>   driver as pincontrol driver.
> - Provide pin configuration through pincntrl framework.
>
> Changes from V3:
> - Added gpio ranges and pinctrl_gpio calls.
> - Used pinctrl_gpio_* calls on gpio chips callback.
> - Remove dummy function which just return not supported.
> - Nit cleanups.
>
> Changes from V4:
> - Drop separate DT binding document as it is moved to mfd/as3722.txt.

As mentioned I am happy with this driver,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

When you agreed with the DT folks and want me to merge it,
tell me.

Yours,
Linus Walleij
