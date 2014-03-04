Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbaCDWGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:06:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45536 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbaCDWGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:06:52 -0500
Message-ID: <53164E78.5010708@wwwdotorg.org>
Date: Tue, 04 Mar 2014 15:06:48 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, linux@roeck-us.net
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
References: <1393932664-13319-1-git-send-email-wni@nvidia.com> <1393932664-13319-4-git-send-email-wni@nvidia.com>
In-Reply-To: <1393932664-13319-4-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 04:31 AM, Wei Ni wrote:
> Add dt node to describe the thermal zone for the nct1008.
> 
> Change-Id: I0256836e52d73ec282574e4fd91df52958936e35

???????

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts

> +	thermal-zones {
> +		nct1008-local {
> +			polling-delay-passive = <2000>; /* milliseconds */

Nothing can possible make use of this node, since there's no compatible
value or anything else like that to bind a driver to it.
