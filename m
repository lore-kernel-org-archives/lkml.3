Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965240Ab3BNRnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:43:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34173 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab3BNRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:43:20 -0500
Message-ID: <511D2234.8000408@wwwdotorg.org>
Date: Thu, 14 Feb 2013 10:43:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: provide dummy cpu car ops
References: <1360853581-9756-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1360853581-9756-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 07:52 AM, Peter De Schrijver wrote:
> tegra_boot_secondary() relies on some of the car ops. This means having an
> uninitialized tegra_cpu_car_ops will lead to an early boot panic.
> Providing a dummy struct avoids this and makes adding Tegra114 clock support
> in a bisectable way a lot easier.
> 
> --
> 
> Stephen,
> 
> Should this be a separate patch or should I make this part of new release of
> the Tegra114 clock series?

I will try and remember to apply this before the Tegra114 clock series,
although I think you're reposting that anyway, so feel free to include
this in that series to make things simpler.

