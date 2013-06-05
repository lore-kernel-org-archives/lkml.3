Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3FENzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:55:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16050 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3FENzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:55:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 06:54:48 -0700
Date: Wed, 5 Jun 2013 16:54:45 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] PLL m,n,p init from SoC files
Message-ID: <20130605135445.GP3847@tbergstrom-lnx.Nvidia.com>
References: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:51:24PM +0200, Peter De Schrijver wrote:
> The m,n,p fields don't have the same bit offset and width across all PLLs.
> This patchset allows SoC specific files to indicate the offset and width.
> It also provides the data for Tegra114.
> 

Depends on 'clk: tegra: pllc and pllxc should use pdiv_map'

Cheers,

Peter.
