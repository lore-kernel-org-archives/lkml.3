Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3FXPLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:11:19 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33994 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3FXPLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <1371720391-21825-5-git-send-email-james.hogan@imgtec.com>
References: <1371720391-21825-1-git-send-email-james.hogan@imgtec.com>
	<1371720391-21825-5-git-send-email-james.hogan@imgtec.com>
Date: Mon, 24 Jun 2013 17:11:17 +0200
Message-ID: <CACRpkda8Un0Y+LA-huFbpw0tkKML5RWT-=OCY3P+OXfd5b4Eaw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] gpio-tz1090-pdc: add TZ1090 PDC gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 11:26 AM, James Hogan <james.hogan@imgtec.com> wrote:

> Add a GPIO driver for the low-power Powerdown Controller GPIOs in the
> TZ1090 SoC.
>
> The driver is instantiated by device tree and supports interrupts for
> the SysWake GPIOs only.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-doc@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
> Changes in v3:
>  - separated from irq-imgpdc and removed arch/metag changes to allow
>    these patches to go upstream separately via the pinctrl[/gpio] trees
>    (particularly the pinctrl drivers depend on the new pinconf DT
>    bindings).
>  - some s/unsigned/unsigned int/.
>  - gpio-tz1090*: refer to <dt-bindings/gpio/gpio.h> and
>    <dt-bindings/interrupt-controller/irq.h> flags in bindings.
>  - gpio-tz1090*: move initcall from postcore to subsys.

I'll be happy to apply the GPIO patches to the pinctrl tree as well
once you fixed the comments on patch 2 from Grant.

Yours,
Linus Walleij
