Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaB1IVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:21:45 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbaB1IVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:21:43 -0500
Message-ID: <5310470D.6000404@nod.at>
Date: Fri, 28 Feb 2014 09:21:33 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
CC: eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, horms@verge.net.au,
        laurent.pinchart+renesas@ideasonboard.com
Subject: Re: [PATCH 2/2] thermal,rcar_thermal: Add dependency on HAS_IOMEM
References: <1390688954-4940-1-git-send-email-richard@nod.at>	<1393484282.2637.17.camel@rzhang1-mobl4> <87fvn4yskv.wl%kuninori.morimoto.gx@gmail.com>
In-Reply-To: <87fvn4yskv.wl%kuninori.morimoto.gx@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.02.2014 01:44, schrieb Kuninori Morimoto:
>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>>> index 35c0664..88efa8f 100644
>>> --- a/drivers/thermal/Kconfig
>>> +++ b/drivers/thermal/Kconfig
>>> @@ -136,6 +136,7 @@ config SPEAR_THERMAL
>>>  config RCAR_THERMAL
>>>  	tristate "Renesas R-Car thermal driver"
>>>  	depends on ARCH_SHMOBILE || COMPILE_TEST
>>> +	depends on HAS_IO_MEM
>>>  	help
>>>  	  Enable this to plug the R-Car thermal sensor driver into the Linux
>>>  	  thermal framework.
> 
> I guess
> 
>  - HAS_IO_MEM
>  + HAS_IOMEM

Yeah, this has been resolved in v2:
https://lkml.org/lkml/2014/1/27/59

Thanks,
//richard
