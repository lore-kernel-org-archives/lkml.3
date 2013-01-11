Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3AKFCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 00:02:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4977 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3AKFCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 00:02:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 10 Jan 2013 21:01:55 -0800
Message-ID: <50EF9CC4.8030600@nvidia.com>
Date: Fri, 11 Jan 2013 10:31:56 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@ni.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "linux@prisktech.co.nz" <linux@prisktech.co.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH 1/7] clk: add common of_clk_init() function
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com> <20130110195347.GN19380@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20130110195347.GN19380@beefymiracle.amer.corp.natinst.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2013 01:23 AM, Josh Cartwright wrote:
> * PGP Signed by an unknown key
>
> On Fri, Jan 04, 2013 at 12:30:52PM +0530, Prashant Gaikwad wrote:
>> Modify of_clk_init function so that it will determine which
>> driver to initialize based on device tree instead of each driver
>> registering to it.
>>
>> Based on a similar patch for drivers/irqchip by Thomas Petazzoni and
>> drivers/clocksource by Stephen Warren.
>>
>> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
>> ---
> Prashant-
>
> Sorry for the late response, but I finally got a chance to give this
> patchset a spin on Zynq.  For patches 1 and 6:
>
> Reviewed-by: Josh Cartwright <josh.cartwright@ni.com>
> Tested-by: Josh Cartwright <josh.cartwright@ni.com>
>
>    Josh

Thanks Josh!!

> * Unknown Key
> * 0x846F0FA5

