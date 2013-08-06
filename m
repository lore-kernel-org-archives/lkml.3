Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3HFMLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:11:53 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3772 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3HFMLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:11:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 Aug 2013 05:11:50 -0700
Message-ID: <5200EB2C.9040103@nvidia.com>
Date: Tue, 6 Aug 2013 17:55:16 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>
Subject: Re: [PATCH V2 1/3] pinctrl: add utility functions for add map/configs
References: <1375688014-6117-1-git-send-email-ldewangan@nvidia.com> <1375688014-6117-2-git-send-email-ldewangan@nvidia.com> <52001B32.7070107@wwwdotorg.org>
In-Reply-To: <52001B32.7070107@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 August 2013 03:07 AM, Stephen Warren wrote:
> On 08/05/2013 01:33 AM, Laxman Dewangan wrote:
>> Some of pincontrol driver needs the utility function to create map
>> list. The utility function needed for adding mux, configs etc.
>>
>> In place of duplicating this in each driver, add the common utility
>> function in common file and use from device specific driver. This will
>> reduce the duplicating of code across drivers.
> This patch,
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Thanks for review.

>
> Some more documentation mnight be useful though, now these are common
> utility functions rather than just some internal functions in the Tegra
> pinctrl driver.
>
> Hopefully there will be a patch to convert at least the Tegra pinctrl
> driver to use these new functions.

Yes, I will have the patches for Tegra also to use these common utils 
functions.
