Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3IJEfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:35:50 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13940 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3IJEft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:35:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Sep 2013 21:35:48 -0700
Message-ID: <522EA1CF.4070605@nvidia.com>
Date: Tue, 10 Sep 2013 12:36:31 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] Documentation: dt: hwmon: add OF document for
 LM90
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-3-git-send-email-wni@nvidia.com> <CALkWK0nqgF6yn4QRe2tTD-Qd+5GLtH-ifCesayk-+uxkWMx-5w@mail.gmail.com> <522EA177.6050608@nvidia.com>
In-Reply-To: <522EA177.6050608@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 12:35 PM, Wei Ni wrote:
> On 09/09/2013 06:57 PM, Ramkumar Ramachandra wrote:
>> Wei Ni wrote:
>>> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt
>>> new file mode 100644
>>> index 0000000..5570875
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/hwmon/lm90.txt
>>
>> While at it, please update and rename ads1015.txt.
> 
> This series is for lm90 compatible devices, it seems ads1015 is not
> register-compatible with lm90.
> 
>>
>>> @@ -0,0 +1,44 @@
>>> +* LM90 series thermometer.
>>> +
>>> +Required node properties:
>>> +- compatible: manufacture and chip name, one of
>>> +               "<manufacture>,adm1032"
>>> +               "<manufacture>,adt7461"
>>> +               "<manufacture>,adt7461a"
>>> +               "<manufacture>,g781"
>>> +               "<manufacture>,lm90"
>>> +               "<manufacture>,lm86"
>>> +               "<manufacture>,lm89"
>>> +               "<manufacture>,lm99"
>>
>> More versions of this of different ages are required.
> 
> In here, the chip names, such as "lm99", come from lm90.c id_table, the
> i2c subsystem want to use it to load driver, so we can add any other names.

Sorry, it's typo, it should be "can't add any other names".

> 
>>
>>> +               "<manufacture>,max6646"
>>> +               "<manufacture>,max6647"
>>> +               "<manufacture>,max6649"
>>> +               "<manufacture>,max6657"
>>> +               "<manufacture>,max6658"
>>> +               "<manufacture>,max6659"
>>> +               "<manufacture>,max6680"
>>> +               "<manufacture>,max6681"
>>> +               "<manufacture>,max6695"
>>> +               "<manufacture>,max6696"
>>
>> SSDNow devices are required.
> What's the SSDNow device? It seems the lm90.c doesn't support it.
> 
> Thanks.
> Wei.
> 
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

