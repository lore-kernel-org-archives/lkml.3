Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab3ICR4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:56:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42598 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab3ICR4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:56:46 -0400
Message-ID: <522622DA.7020907@wwwdotorg.org>
Date: Tue, 03 Sep 2013 11:56:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra114: add missing clocks to binding
References: <1378213637-9948-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1378213637-9948-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 07:07 AM, Peter De Schrijver wrote:
> commit 992bb598f690542a2f539fd12a42b960b7692025 forgot to move dfll_soc and
> dfll_ref to include/dt-bindings/clock/tegra114-car.h. Add them again in this
> patch as TEGRA114_CLK_DFLL_SOC and TEGRA114_CLK_DFLL_REF.

Acked-by: Stephen Warren <swarren@nvidia.com>

I assume this will go through Mike's clock tree along with the driver
changes that rely on it.
