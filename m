Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215AbaDJQvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:51:19 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43928 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaDJQvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ1Lt2JsMMWVMBgfS8ktkpeYzA3MiGmWB27Jwhw16UYYg@mail.gmail.com>
References: <1390509887-19278-1-git-send-email-syin@broadcom.com>
	<1396478439-16586-1-git-send-email-syin@broadcom.com>
	<1396478439-16586-2-git-send-email-syin@broadcom.com>
	<CACRpkdZ1Lt2JsMMWVMBgfS8ktkpeYzA3MiGmWB27Jwhw16UYYg@mail.gmail.com>
Date: Thu, 10 Apr 2014 18:51:12 +0200
Message-ID: <CACRpkdbY58J7GcQnYcUVTkfVO3VNCyJa0zVTKV4ibF8khxD8EA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pinctrl: Rename Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Mark Brown <broonie@kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 6:49 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Apr 3, 2014 at 12:40 AM, Sherman Yin <syin@broadcom.com> wrote:
>
>> To be consistent with other Broadcom drivers, the Broadcom Capri pinctrl
>> driver and its related CONFIG option are renamed to bcm281xx.
>>
>> Devicetree compatible string and binding documentation use
>> "brcm,bcm11351-pinctrl" to match the machine binding here:
>> Documentation/devicetree/bindings/arm/bcm/bcm11351.txt
>>
>> This driver supports pinctrl on BCM11130, BCM11140, BCM11351, BCM28145
>> and BCM28155 SoCs.
>>
>> Signed-off-by: Sherman Yin <syin@broadcom.com>
>> Reviewed-by: Matt Porter <mporter@linaro.org>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  drivers/pinctrl/Kconfig                            |    8 +-
>>  drivers/pinctrl/Makefile                           |    2 +-
>>  .../{pinctrl-capri.c => pinctrl-bcm281xx.c}        | 1519 ++++++++++----------
>
> This last version from apr 7 does not change
> arch/arm/configs/bcm_defconfig:CONFIG_PINCTRL_CAPRI=y
>
> Doesn't this mean that you render this platform without a pin
> control driver and thus broken?

Bah I see that it's a separate patch now, sorry...

Looking closer.

Yours,
Linus Walleij
