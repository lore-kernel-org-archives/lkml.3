Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab3LWIQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:16:49 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:37814 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3LWIQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:16:47 -0500
MIME-Version: 1.0
In-Reply-To: <1387462990-12039-10-git-send-email-mporter@linaro.org>
References: <1387462990-12039-1-git-send-email-mporter@linaro.org>
	<1387462990-12039-10-git-send-email-mporter@linaro.org>
Date: Mon, 23 Dec 2013 00:16:46 -0800
Message-ID: <CAEPRUYoaV0B8kUiLGD6cdzXkSvftY7ZB1uqh3jfRsBAvK3+JVg@mail.gmail.com>
Subject: Re: [PATCH v8 9/9] ARM: dts: add usb udc support to bcm281xx
From: Christian Daudt <bcm@fixthebug.org>
To: Matt Porter <mporter@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 6:23 AM, Matt Porter <mporter@linaro.org> wrote:
> Adds USB OTG/PHY and clock support to BCM281xx and enables
> UDC support on the bcm11351-brt and bcm28155-ap boards.
>
> Signed-off-by: Matt Porter <mporter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>

Applied to armsoc/for-3.14/dt

 thanks,
   csd
