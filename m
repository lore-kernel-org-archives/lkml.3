Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3KZUHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:07:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51643 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3KZUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:07:34 -0500
Message-ID: <5294FF83.7040905@wwwdotorg.org>
Date: Tue, 26 Nov 2013 13:07:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: add TEGRA_DIVIDER_ROUND_UP for periph clks
References: <1385484495-9835-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1385484495-9835-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 09:48 AM, Peter De Schrijver wrote:
> Perform upwards rounding when calculating dividers for periph clks on Tegra30
> and Tegra114.

Tested-by: Stephen Warren <swarren@nvidia.com>

I tested audio and SPI on Dalmore and Beaver, using the following branch
which has this commit integrated:
git://nv-tegra.nvidia.com/user/pdeschrijver/linux tegra-clk-rework-1
