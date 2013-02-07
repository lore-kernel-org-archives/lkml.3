Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3BGTNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:13:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51514 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759025Ab3BGTNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:13:52 -0500
Message-ID: <5113FCEE.20400@wwwdotorg.org>
Date: Thu, 07 Feb 2013 12:13:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: local arrays should be static
References: <1360254640-25831-1-git-send-email-pdeschrijver@nvidia.com> <20130207174949.11471.27667@quantum>
In-Reply-To: <20130207174949.11471.27667@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 10:49 AM, Mike Turquette wrote:
> Quoting Peter De Schrijver (2013-02-07 08:30:36)
>> cclk_g_parents, cclk_lp_parents and sclk_parents are only accessed from within
>> clk-tegra30.c. Declare them static to avoid namespace polution.
>>
>> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>

I've applied this to Tegra's for-3.9/soc-ccf-fixes branch.

