Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3JKIOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:14:34 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61404 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3JKIOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:14:30 -0400
MIME-Version: 1.0
In-Reply-To: <051069C10411E24D9749790C498526FA1BE027EA@SJEXCHMB12.corp.ad.broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<1380846199-12829-4-git-send-email-syin@broadcom.com>
	<CACRpkdZah4fFuJL2Vh5JmbBCgnekg8MKqMWHzeheOx3N1Kzwng@mail.gmail.com>
	<051069C10411E24D9749790C498526FA1BE027EA@SJEXCHMB12.corp.ad.broadcom.com>
Date: Fri, 11 Oct 2013 10:14:29 +0200
Message-ID: <CACRpkdarPC+LxAAezT2LRiz=Y2RduUsb75YYHUgq7HqePzkD3Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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

On Fri, Oct 11, 2013 at 1:48 AM, Sherman Yin <syin@broadcom.com> wrote:

>>> +static const struct capri_cfg_param capri_pinconf_params[] = {
>>> +       {"brcm,hysteresis",     CAPRI_PINCONF_PARAM_HYST},
>>> +       {"brcm,pull",           CAPRI_PINCONF_PARAM_PULL},
>>> +       {"brcm,slew",           CAPRI_PINCONF_PARAM_SLEW},
>>> +       {"brcm,input_dis",      CAPRI_PINCONF_PARAM_INPUT_DIS},
>>> +       {"brcm,drive_str",      CAPRI_PINCONF_PARAM_DRV_STR},
>>> +       {"brcm,pull_up_str",    CAPRI_PINCONF_PARAM_PULL_UP_STR},
>>> +       {"brcm,mode",           CAPRI_PINCONF_PARAM_MODE},
>>> +};
>>
>>As well as all this stuff...
>
> OK.  Will see if I can find something suitable for "input disable" and "mode"

Let's discuss this. What exactly does "input disable" and "mode"
mean, in electrical terms?

When you come down to what actually happens it may turn out that
"input disable" is PIN_CONFIG_OUTPUT, which implicitly turns
off input does it not?

Yours,
Linus Walleij
