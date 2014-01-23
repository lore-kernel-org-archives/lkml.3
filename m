Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaAWIg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:36:57 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47116 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaAWIgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:36:55 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ+3MC8XpfD-vumvq3yQACzFn89DQjWQeXbdBK+9JmfLQ@mail.gmail.com>
References: <1390343886-25852-1-git-send-email-syin@broadcom.com>
	<CACRpkdZ+3MC8XpfD-vumvq3yQACzFn89DQjWQeXbdBK+9JmfLQ@mail.gmail.com>
Date: Thu, 23 Jan 2014 09:36:54 +0100
Message-ID: <CACRpkdbEtQCBeMr-vM1prD8hOcPOdMfH_-pGt5aesPYKZ2n4Zg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Rename Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>, "arm@kernel.org" <arm@kernel.org>
Cc: Mark Brown <broonie@kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
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

On Thu, Jan 23, 2014 at 9:17 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jan 21, 2014 at 11:38 PM, Sherman Yin <syin@broadcom.com> wrote:
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
>
> Patch applied for fixes.

No wait. I took the patch out.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

This driver is already causing a messy conflict situation in ARM SoC.
I don't want to escalate their problem.

Either you merge this through ARM SoC or split off the arch/arm/*
changes into a separate patch for ARM SoC.

Yours,
Linus Walleij
