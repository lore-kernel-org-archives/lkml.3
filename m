Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaGUWh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:37:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54503 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaGUWhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:37:23 -0400
Message-ID: <53CD9620.3090301@wwwdotorg.org>
Date: Mon, 21 Jul 2014 16:37:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, pdeschrijver@nvidia.com,
        pgaikwad@nvidia.com, mturquette@linaro.org, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/8] ARM: tegra: Remove TEGRA124_CLK_EMC from tegra124-car.h
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-3-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1405088313-20048-3-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
> Remove the TEGRA124_CLK_EMC cell value define for tegra124-car
> from the binding headers. This clock has never been able to do
> anything and is being replaced with a separate EMC driver with
> its own device tree node. Removing the define ensures that any
> user will not mistakenly refer to <&tegra_car TEGRA124_CLK_EMC>
> instead of <&emc> or similar.

If the clock physically exists in HW, I see no reason to remove it from
the binding definition, even if we don't implement it (or remove the
implementation of it) in the Linux clock driver.
