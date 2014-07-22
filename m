Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbaGVRSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:18:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36490 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaGVRSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:18:38 -0400
Message-ID: <53CE9CEA.2060200@wwwdotorg.org>
Date: Tue, 22 Jul 2014 11:18:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/6] clk: tegra: add nvidia,tegra132-ccplex-clk binding
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com> <1405437890-6468-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1405437890-6468-5-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 09:24 AM, Peter De Schrijver wrote:
> Tegra132 has a few new clocks for the CPU complex (ccplex).

> diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra132-ccplex-clk.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra132-ccplex-clk.txt

> +Example SoC include file:
> +
> +/ {
> +	ccplex-clock@0,70040000 {
> +		compatible = "nvidia,tegra132-ccplex-clk";
> +		reg = <0x0 0x70040000 0x0 0x1000>;
> +		status = "okay";

That's the default, so it's not worth including that property.

