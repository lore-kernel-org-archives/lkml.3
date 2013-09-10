Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3IJEYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:24:50 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13612 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3IJEYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:24:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Sep 2013 21:24:47 -0700
Message-ID: <522E9F33.3010004@nvidia.com>
Date: Tue, 10 Sep 2013 12:25:23 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] Documentation: dt: hwmon: add OF document for
 LM90
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-3-git-send-email-wni@nvidia.com> <522DA86B.6000603@roeck-us.net> <522E4854.1050800@wwwdotorg.org>
In-Reply-To: <522E4854.1050800@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 06:14 AM, Stephen Warren wrote:
> On 09/09/2013 04:52 AM, Guenter Roeck wrote:
>> On 09/09/2013 03:29 AM, Wei Ni wrote:
>>> Add OF document for LM90 in Documentation/devicetree/.
> 
>>> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt
> 
>>> +* LM90 series thermometer.
>>> +
>>> +Required node properties:
>>> +- compatible: manufacture and chip name, one of
>>
>> manufacturer
>>
>>> +        "<manufacture>,adm1032"
> ...
>>> +        "<manufacture>,sa56004"
>>
>> Shouldn't the manufacturers be listed explicitly ?
> 
> Yes, and they must all be present in
> Documentation/devicetree/bindings/vendor-prefixes.txt.

Oh, got it, I will update it, thanks.

> 
>>> +Example LM90 node:
>>> +
>>> +temp-sensor {
>>> +    compatible = "onnn,nct1008";
>>> +    reg = <0x4c>;
>>> +    vcc-supply = <&palmas_ldo6_reg>;
>>> +    interrupt-parent = <&gpio>;
>>
>> List above as optional property.
> 
> I believe it's common not to document this, since it's implicitly
> supported as part of any node that is an interrupt source.
> 

