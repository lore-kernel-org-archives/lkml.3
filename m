Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3JHW3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 18:29:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44313 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3JHW3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 18:29:05 -0400
Message-ID: <5254872C.9010307@wwwdotorg.org>
Date: Tue, 08 Oct 2013 16:29:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/5] clk: tegra124: Add common clk IDs to clk-id.h
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com> <1380878014-22088-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1380878014-22088-4-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 03:12 AM, Peter De Schrijver wrote:
> Tegra124 introduces a number of a new clocks. Introduce the corresponding
> the IDs for them.

> diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h

> +	tegra124_clk_isp,

Why does that one clock have a "tegra124_" name prefix, whereas all the
rest are just "tegra_"?
