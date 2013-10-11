Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3JKSZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:25:32 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1525 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab3JKSZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:25:30 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Sherman Yin" <syin@broadcom.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
Thread-Topic: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl
 driver
Thread-Index: AQHOwJjvlt3ZyknjmUucDC303MwucJnskuoAgAHzuwCAASFSgIAANMjQ
Date: Fri, 11 Oct 2013 18:25:16 +0000
Message-ID: <051069C10411E24D9749790C498526FA1BE03D43@SJEXCHMB12.corp.ad.broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
 <1380846199-12829-4-git-send-email-syin@broadcom.com>
 <CACRpkdZah4fFuJL2Vh5JmbBCgnekg8MKqMWHzeheOx3N1Kzwng@mail.gmail.com>
 <051069C10411E24D9749790C498526FA1BE027EA@SJEXCHMB12.corp.ad.broadcom.com>
 <CACRpkdarPC+LxAAezT2LRiz=Y2RduUsb75YYHUgq7HqePzkD3Q@mail.gmail.com>
In-Reply-To: <CACRpkdarPC+LxAAezT2LRiz=Y2RduUsb75YYHUgq7HqePzkD3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E469D064FK832536-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> +static const struct capri_cfg_param capri_pinconf_params[] = {
>>>> +       {"brcm,hysteresis",     CAPRI_PINCONF_PARAM_HYST},
>>>> +       {"brcm,pull",           CAPRI_PINCONF_PARAM_PULL},
>>>> +       {"brcm,slew",           CAPRI_PINCONF_PARAM_SLEW},
>>>> +       {"brcm,input_dis",      CAPRI_PINCONF_PARAM_INPUT_DIS},
>>>> +       {"brcm,drive_str",      CAPRI_PINCONF_PARAM_DRV_STR},
>>>> +       {"brcm,pull_up_str",    CAPRI_PINCONF_PARAM_PULL_UP_STR},
>>>> +       {"brcm,mode",           CAPRI_PINCONF_PARAM_MODE},
>>>> +};
>>>
>>>As well as all this stuff...
>>
>> OK.  Will see if I can find something suitable for "input disable" and "mode"
>
>Let's discuss this. What exactly does "input disable" and "mode"
>mean, in electrical terms?
>
>When you come down to what actually happens it may turn out that
>"input disable" is PIN_CONFIG_OUTPUT, which implicitly turns
>off input does it not?

I'm going to verify the details with our hardware team first, and will let you
know if we think we can use one of the existing generic parameters or if we
need a new one.

Regards,
Sherman

