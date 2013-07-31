Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab3GaL7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:59:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50008 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759458Ab3GaL67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:58:59 -0400
Message-ID: <51F8FBEE.6060807@ti.com>
Date: Wed, 31 Jul 2013 06:58:38 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
References: <1375185957-28212-1-git-send-email-bilhuang@nvidia.com>  <51F7BCEC.9080803@ti.com> <1375251767.32701.5.camel@bilhuang-vm1>
In-Reply-To: <1375251767.32701.5.camel@bilhuang-vm1>
Content-Type: text/plain; charset="ISO-8859-9"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 01:22 AM, Bill Huang wrote:
> On Tue, 2013-07-30 at 21:17 +0800, Nishanth Menon wrote:
>> On 07/30/2013 07:05 AM, Bill Huang wrote:
[...]

>>> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
>>> index 30b0581..4adca2a 100644
>>> --- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
>>> +++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
>>> @@ -36,6 +36,9 @@ Optional nodes:
>>>    	       ti,smps-range - OTP has the wrong range set for the hardware so override
>>>    	       0 - low range, 1 - high range.
>>>
>>> +- ti,system-power-controller: Telling whether or not this pmic is controlling
>> controller or master?
>
> We name it controller since it controls the system power of the
> platform, I'm not sure will it make more sense to be master? Or does it
> makes sense to other pmic which also control the system power (the same
> property are already used in pmic TPS6586x and TPS65910).


No strong feelings either way, especially if there is precedence.

-- 
Regards,
Nishanth Menon
