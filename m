Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaIJRCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:02:17 -0400
Received: from mout.gmx.net ([212.227.15.18]:54600 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaIJRCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:02:16 -0400
Message-ID: <54108939.5050208@gmx.net>
Date: Wed, 10 Sep 2014 19:24:09 +0200
From: Stefan Wahren <wahrenst@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        "festevam@gmail.com" <festevam@gmail.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 2/3] ARM: regulator: add Freescale MXS regulator driver
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de> <1410089869-6611-3-git-send-email-info@lategoodbye.de> <20140909182211.GG3896@leverpostej> <540F523D.4010904@lategoodbye.de> <20140910141853.GA4994@leverpostej>
In-Reply-To: <20140910141853.GA4994@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:PeY6MSEjqT/iHQHmU6E5Z+zfXFlpRAsFb4SAEjS/yOUQoa0g3yF
 cBRHUNca4VL1+9Eu6Dwc8BEpUgTSsycud5KwTpCi1ttao1W6IkYWOha1WI7nFZl40wI7rjm
 bqHl90I1s7qMLY/VD4K+I6pPkx3j3euVIY2ltX0G+b/pjpIHPthVTZeYDH3I+HxJb6Pgfjm
 wl6LVO0Jdjak6Vdg2Jx4g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 10.09.2014 16:18, schrieb Mark Rutland:
>[...]
>
>>>> +       of_property_read_u32(np, "mxs-default-microvolt",
>>>> +                                  &val);
>>>> +
>>>> +       if (val)
>>>> +               mxs_set_voltage(rdev, val, val, NULL);
>>>
>>> As I mentioned in my comments on the binding, I'd like to know why this
>>> is necessary and if it is why it shouldn't be a standardised property.
>>
>>   From my understanding the standardised properties only defines a range,
>> but no default state of the regulators. If the initialization from the
>> bootloader or a hardcoded initialization in the driver is okay then the
>> property is not necessary.
>
> Sure. My questions was why it is necessary to preconfigure the
> regulators at all rather than why it is necessary to do so in this
> manner.
>
> Mark.
>

sorry i don't have a clue. In the original code there isn't a comment 
about the reason. Currently there is no init of the vddio regulator by 
the kernel and everything works fine.

@Fabio: Do you have any doubts?

Stefan
