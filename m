Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab3KZSaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:30:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51480 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab3KZSax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:30:53 -0500
Message-ID: <5294E8B6.5000102@ti.com>
Date: Tue, 26 Nov 2013 13:30:14 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
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
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-8-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com> <52944BD3.90105@ti.com> <5294DE17.9080900@ti.com>
In-Reply-To: <5294DE17.9080900@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan,

On Tuesday 26 November 2013 12:44 PM, ivan.khoronzhuk wrote:
> On 11/26/2013 09:20 AM, Sekhar Nori wrote:
>> On Monday 11 November 2013 10:36 PM, Khoronzhuk, Ivan wrote:

>>> +static struct platform_driver davinci_aemif_driver = {
>>> +       .probe = davinci_aemif_probe,
>>> +       .remove = davinci_aemif_remove,
>>> +       .driver = {
>>> +               .name = DRV_NAME,
>>> +               .owner = THIS_MODULE,
>>> +               .of_match_table = of_match_ptr(davinci_aemif_of_match),
>>> +       },
>>> +};
>>> +
>>> +module_platform_driver(davinci_aemif_driver);
>>> +
>>> +MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
>>
>> Is this correct? If yes, I would have expected him to sign-off on the
>> patch too. If not, please drop this.
> 
> I will add sign-off
> 
Please add you as a MODULE_AUTHOR as well since you re-wrote the
downstream driver. Ok to have both of you sign of on it.

Regards,
Santosh

