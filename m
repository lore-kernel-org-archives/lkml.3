Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3IWQ6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:58:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56351 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3IWQ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:58:34 -0400
Message-ID: <52407335.3030403@wwwdotorg.org>
Date: Mon, 23 Sep 2013 10:58:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, broonie@kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        rtc-linux@googlegroups.com, rob.herring@calxeda.com,
        mark.rutland@arm.com, pawel.moll@arm.com, rob@landley.net,
        ijc+devicetree@hellion.org.uk, grant.likely@linaro.org,
        florian.lobmaier@ams.com
Subject: Re: [PATCH 3/4] regulator: as3722: add regulator driver for AMS AS3722
References: <1379400338-20704-1-git-send-email-ldewangan@nvidia.com> <1379400338-20704-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379400338-20704-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 12:45 AM, Laxman Dewangan wrote:
> The AS3722 is a compact system PMU suitable for Mobile Phones,
> Tablet etc. It has 4 DCDC step down regulators, 3 DCDC step down
> controller, 11 LDOs.
> 
> Add a driver to support accessing the DCDC/LDOs found on the AMS
> AS3722 PMIC using regulators.

> diff --git a/Documentation/devicetree/bindings/regulator/as3722-reguator.txt b/Documentation/devicetree/bindings/regulator/as3722-reguator.txt

The filename is typo'd

> +AMS AS3722 regulator devicetree bindings.
> +The regulator node is sub node of the AS3722 node.

You probably want a blank line to separate the document title from the
body text.

> +Optional nodes:
> +- regulators : Must contain a sub-node per regulator from the list below.
> +	       Each sub-node should contain the constraints and initialization
> +	       information for that regulator. See regulator.txt for a
> +	       description of standard properties for these sub-nodes.
> +	       Additional custom properties  are listed below.
> +	       sd[0-6], ldo[0-7], ldo[9-11].

I think you want to prefix that last line with something like: "Valid
regulator names are: ".

> +		ams,ext-control: External control of the rail. The option of
> +			this properties will tell which external input is
> +			controlling this rail. Valid values are 0, 1, 2 ad 3.
> +			0: There is no external control of this rail.
> +			1: Rail is controlled by ENABLE1 input pin.
> +			2: Rail is controlled by ENABLE1 input pin.
> +			3: Rail is controlled by ENABLE1 input pin.

Those last 3 lines all say the same thing.

