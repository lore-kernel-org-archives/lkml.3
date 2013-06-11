Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3FKHTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:19:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16458 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3FKHTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:19:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 11 Jun 2013 00:19:02 -0700
Message-ID: <51B6CF60.9020600@nvidia.com>
Date: Tue, 11 Jun 2013 12:48:56 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clk: tegra: Use common of_clk_init function
References: <1369640409-1981-1-git-send-email-pgaikwad@nvidia.com> <51A4CA6A.8090103@wwwdotorg.org>
In-Reply-To: <51A4CA6A.8090103@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 May 2013 08:46 PM, Stephen Warren wrote:
> On 05/27/2013 01:40 AM, Prashant Gaikwad wrote:
>> Use common of_clk_init() function for clocks initialization.

Mike,

Please merge this patch in your tree.

Thanks,
PrashantG
> Acked-by: Stephen Warren <swarren@nvidia.com>

