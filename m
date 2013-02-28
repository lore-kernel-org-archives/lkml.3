Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3B1XgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:36:04 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:40055 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3B1XgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:36:01 -0500
Message-ID: <512FE9D6.1010907@slimlogic.co.uk>
Date: Thu, 28 Feb 2013 23:35:50 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, ldewangan@nvidia.com,
        j-keerthy@ti.com, gg@slimlogic.co.uk, cooloney@gmail.com,
        rpurdie@rpsys.net, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2 1/2] leds: Add support for Palmas LEDs
References: <1362064909-634-1-git-send-email-ian@slimlogic.co.uk> <512FA39D.2060005@wwwdotorg.org>
In-Reply-To: <512FA39D.2060005@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 18:36, Stephen Warren wrote:
> On 02/28/2013 08:21 AM, Ian Lartey wrote:
>> The Palmas familly of chips has LED support. This is not always muxed
>> to output pins so depending on the setting of the mux this driver
>> will create the appropriate LED class devices.
>
>> +static struct of_device_id of_palmas_match_tbl[] = {
>> +	{ .compatible = "ti,palmas-leds", },
>> +	{ /* end */ }
>> +};
>
> Is there DT binding documentation for this compatible value somewhere?

I think with the other palmas DT discussions this may be subject
to change. Once thay are resolved we'll get the documentation updated

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

