Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3BFMWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:22:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5593 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3BFMWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:22:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 06 Feb 2013 04:20:26 -0800
Date: Wed, 6 Feb 2013 14:22:39 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: initialise parent of uart clocks
Message-ID: <20130206122239.GH3073@tbergstrom-lnx.Nvidia.com>
References: <1360147661-5435-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1360147661-5435-1-git-send-email-ldewangan@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 11:47:41AM +0100, Laxman Dewangan wrote:
> Initialise the parent of UARTs to PLLP and disabling clock by
> default.
> 

I wonder if we should move the parent definitions to DT at some point.

Cheers,

Peter.
