Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaHTTnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:43:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44656 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaHTTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:43:39 -0400
Message-ID: <53F4FA80.9050103@wwwdotorg.org>
Date: Wed, 20 Aug 2014 13:44:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        edubezval@gmail.com, thierry.reding@gmail.com
CC: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/4] ARM: tegra: Add thermal trip points for Jetson
 TK1
References: <1407320706-17440-1-git-send-email-mperttunen@nvidia.com> <1407320706-17440-4-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1407320706-17440-4-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 04:25 AM, Mikko Perttunen wrote:
> This adds critical trip points to the Jetson TK1 device tree.
> The device will do a controlled shutdown when either the CPU, GPU
> or MEM thermal zone reaches 101 degrees Celsius.

> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts

> +	thermal-zones {
> +		cpu {
> +			trips {
...
> +			};
> +		};

thermal.txt states that a cooling-maps sub-node is mandatory. However, 
it seems to be missing here. Is the DT binding documentation overly 
strict, or do we need to add such a node here?
