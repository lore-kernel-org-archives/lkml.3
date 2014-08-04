Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaHDGfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:35:25 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3983 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaHDGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:35:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 03 Aug 2014 23:26:46 -0700
Message-ID: <53DF29A8.1030604@nvidia.com>
Date: Mon, 4 Aug 2014 09:35:20 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Implement memory-controller clock
References: <1406894945-32069-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1406894945-32069-1-git-send-email-thierry.reding@gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm curious why you used emc_mux as the parent clock? (I don't really 
understand why this clock exists, and my EMC series removes it). Using 
'emc' would be compatible with the EMC series :)

A minor one: the MC clock should probably be always enabled.

Apart from these:

Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Tested-by: Mikko Perttunen <mperttunen@nvidia.com>

Cheers,
Mikko

On 01/08/14 15:09, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> The memory controller clock runs either at half or the same frequency as
> the EMC clock.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ...
