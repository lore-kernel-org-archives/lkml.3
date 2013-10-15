Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677Ab3JOTh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:37:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49980 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3JOTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:37:27 -0400
Message-ID: <525D9973.2070501@wwwdotorg.org>
Date: Tue, 15 Oct 2013 13:37:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 13/19] clk: tegra: introduce common gen4 super clock
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-14-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-14-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> Introduce a common function which super clock initialization for Tegra114
> and beyond.

Nit: s/which/{which,that} performs/ ?

For my education, why are cclk_g, cclk_lp, pll_x related to the super
clock? I thought sclk/hclk/pclk were bus clocks, not something related
to the CPU clock(s).
