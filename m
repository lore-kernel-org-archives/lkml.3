Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3DCRzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:55:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46107 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762820Ab3DCRzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:55:46 -0400
Message-ID: <515C6D1C.60503@wwwdotorg.org>
Date: Wed, 03 Apr 2013 11:55:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <achew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 10/14] ARM: tegra: Define Tegra114 CAR binding
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com> <1365000110-8916-10-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1365000110-8916-10-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 08:40 AM, Peter De Schrijver wrote:
> The device tree binding models Tegra114 CAR (Clock And Reset) as a single
> monolithic clock provider.

> diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt

> +Mux clocks
> +
> +  300	audio0_mux
> +  301	audio1_mux
> +  302	audio2_mux
> +  303	audio3_mux
> +  304	audio4_mux
> +  305	spdif_mux
> +  306	clk_out_1_mux
> +  307	clk_out_2_mux
> +  308	clk_out_3_mux
> +  309	dsia_mux
> +  310	dsib_mux

I think Prashant was expecting those to be removed, and for this series
to rely on "clk: Add composite clock type" instead?
