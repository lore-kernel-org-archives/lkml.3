Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab3KZScG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:32:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51533 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab3KZScD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:32:03 -0500
Message-ID: <5294E8DC.3070404@ti.com>
Date: Tue, 26 Nov 2013 20:30:52 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/12] memory: davinci-aemif: introduce AEMIF driver
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-8-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com> <52944BD3.90105@ti.com> <5294DE17.9080900@ti.com> <5294E8B6.5000102@ti.com>
In-Reply-To: <5294E8B6.5000102@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 08:30 PM, Santosh Shilimkar wrote:
> Ivan,
>
> On Tuesday 26 November 2013 12:44 PM, ivan.khoronzhuk wrote:
>> On 11/26/2013 09:20 AM, Sekhar Nori wrote:
>>> On Monday 11 November 2013 10:36 PM, Khoronzhuk, Ivan wrote:
>
>>>> +static struct platform_driver davinci_aemif_driver = {
>>>> +       .probe = davinci_aemif_probe,
>>>> +       .remove = davinci_aemif_remove,
>>>> +       .driver = {
>>>> +               .name = DRV_NAME,
>>>> +               .owner = THIS_MODULE,
>>>> +               .of_match_table = of_match_ptr(davinci_aemif_of_match),
>>>> +       },
>>>> +};
>>>> +
>>>> +module_platform_driver(davinci_aemif_driver);
>>>> +
>>>> +MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
>>>
>>> Is this correct? If yes, I would have expected him to sign-off on the
>>> patch too. If not, please drop this.
>>
>> I will add sign-off
>>
> Please add you as a MODULE_AUTHOR as well since you re-wrote the
> downstream driver. Ok to have both of you sign of on it.
>
> Regards,
> Santosh
>

Ok

-- 
Regards,
Ivan Khoronzhuk
