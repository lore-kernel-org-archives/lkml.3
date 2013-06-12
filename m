Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab3FLBBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:01:31 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34299 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3FLBBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:01:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130612010124.8816.81006@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v2 0/4] Override bits for PLLM
Date: Tue, 11 Jun 2013 18:01:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-06-06 03:47:27)
> PLLM has override bits on Tegra30 and Tegra114. This patchset implements
> support for them for both Tegra30 and Tegra114.
> 
> Changes since v1:
>  * Remove some stray lines from 'clk: tegra: override bits for Tegra114 PLLM'

Pulled into clk-next.

Regards,
Mike

> 
> Peter De Schrijver (4):
>   clk: tegra: Add fields for override bits
>   clk: tegra: override bits for Tegra114 PLLM
>   clk: tegra: override bits for Tegra30 PLLM
>   clk: tegra: Use override bits when needed
> 
>  drivers/clk/tegra/clk-pll.c      |   82 ++++++++++++++++++++++---------------
>  drivers/clk/tegra/clk-tegra114.c |    9 ++++
>  drivers/clk/tegra/clk-tegra30.c  |   18 ++++++++
>  drivers/clk/tegra/clk.h          |    8 ++++
>  4 files changed, 84 insertions(+), 33 deletions(-)
> 
> -- 
> 1.7.7.rc0.72.g4b5ea.dirty
