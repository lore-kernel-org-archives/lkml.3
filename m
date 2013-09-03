Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3ICNfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:35:05 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4460 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab3ICNfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:35:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Sep 2013 06:35:02 -0700
Date: Tue, 3 Sep 2013 16:34:59 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Mike Turquette" <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Introduce table driven initializations
Message-ID: <20130903133459.GP9594@tbergstrom-lnx.Nvidia.com>
References: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 03:31:30PM +0200, Peter De Schrijver wrote:
> This patchset introduces a table driven initialization method for the
> audio, PMC and gate clocks. It's similar to the table we already have for
> the periph clocks.

Forgot to mention this series depends on:

[PATCH] clk: tegra: replace enum tegra114_clk by binding header

