Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaG2I2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:28:43 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13812 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaG2I2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:28:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jul 2014 01:16:27 -0700
Message-ID: <53D75B34.6030403@nvidia.com>
Date: Tue, 29 Jul 2014 11:28:36 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/8] ARM: tegra: Remove TEGRA124_CLK_EMC from tegra124-car.h
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-3-git-send-email-mperttunen@nvidia.com> <53CD9620.3090301@wwwdotorg.org>
In-Reply-To: <53CD9620.3090301@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, I'll drop this one.

- Mikko

On 22/07/14 01:37, Stephen Warren wrote:
> On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
>> Remove the TEGRA124_CLK_EMC cell value define for tegra124-car
>> from the binding headers. This clock has never been able to do
>> anything and is being replaced with a separate EMC driver with
>> its own device tree node. Removing the define ensures that any
>> user will not mistakenly refer to <&tegra_car TEGRA124_CLK_EMC>
>> instead of <&emc> or similar.
>
> If the clock physically exists in HW, I see no reason to remove it from
> the binding definition, even if we don't implement it (or remove the
> implementation of it) in the Linux clock driver.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
