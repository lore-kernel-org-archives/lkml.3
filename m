Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3JQXop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:44:45 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:47140 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3JQXon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <1382013526-12800-11-git-send-email-pdeschrijver@nvidia.com>
References: <1382013526-12800-1-git-send-email-pdeschrijver@nvidia.com>
	<1382013526-12800-11-git-send-email-pdeschrijver@nvidia.com>
Date: Thu, 17 Oct 2013 16:44:41 -0700
X-Google-Sender-Auth: IcMIwYLTp10rj5pX07AmXLSNv9Y
Message-ID: <CAL1qeaFeUevACE_ETqV7Ytzi2mk5bPANzfEAQ0uLWmw=iGELTA@mail.gmail.com>
Subject: Re: [PATCH v4 10/15] clk: tegra: move audio clk to common file
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> +static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {

Not really a big deal, but a lot of these clocks are not audio
related.  Maybe they should be added when the common infrastructure to
deal with them is added?

Thanks,
Andrew
