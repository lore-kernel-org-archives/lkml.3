Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab3FLAj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:39:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52038 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3FLAj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:39:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130612003951.8816.41684@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 0/2] PLL m,n,p init from SoC files
Date: Tue, 11 Jun 2013 17:39:51 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-06-05 06:51:24)
> The m,n,p fields don't have the same bit offset and width across all PLLs.
> This patchset allows SoC specific files to indicate the offset and width.
> It also provides the data for Tegra114.
> 

Taken into clk-next.

Thanks,
Mike

> Peter De Schrijver (2):
>   clk: tegra: allow PLL m,n,p init from SoC files
>   clk: tegra: PLL m,n,p init for Tegra114
> 
>  drivers/clk/tegra/clk-pll.c      |   60 ++++++++++++++++-------------
>  drivers/clk/tegra/clk-tegra114.c |   77 ++++++++++++++++++++++++++++++++++++++
>  drivers/clk/tegra/clk.h          |   32 ++++++++++------
>  3 files changed, 130 insertions(+), 39 deletions(-)
> 
> -- 
> 1.7.7.rc0.72.g4b5ea.dirty
