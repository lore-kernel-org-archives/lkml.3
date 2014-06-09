Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaFIHK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:10:58 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4759 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaFIHKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:10:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jun 2014 00:02:24 -0700
Message-ID: <53955DE9.3090201@nvidia.com>
Date: Mon, 9 Jun 2014 12:40:33 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob@landley.net" <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V5 REPOST] mfd: add support for ams AS3722 PMIC
References: <1382427526-2390-1-git-send-email-ldewangan@nvidia.com> <20140606152840.GV24240@lee--X1>
In-Reply-To: <20140606152840.GV24240@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2014 08:58 PM, Lee Jones wrote:
> Laxman,
>
> This patch has already been applied, but ...
>
> +	as3722->en_intern_int_pullup = of_property_read_bool(np,
> +					"ams,enable-internal-int-pullup");
> +	as3722->en_intern_i2c_pullup = of_property_read_bool(np,
> +					"ams,enable-internal-i2c-pullup");
> These are still not documented.  Can you please do so?
>

Sure, Thanks for pointing this out. I sent the patch.
Thanks,
Laxman
