Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaIQPTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:19:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57324 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaIQPTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:19:07 -0400
Message-ID: <5419A67B.8060909@wwwdotorg.org>
Date: Wed, 17 Sep 2014 09:19:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH] clk: tegra: Make clock initialization more robust
References: <1410946457-24669-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1410946457-24669-1-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 03:34 AM, Tomeu Vizoso wrote:
> Don't abort clock initialization if we cannot match an entry in
> tegra_clk_init_table to a valid entry in the clk array.
>
> Also log a corresponding error message.
>
> This was discovered when testing a patch that removed the EMC clock from
> tegra124_clks but left a mention in tegra_clk_init_table.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
