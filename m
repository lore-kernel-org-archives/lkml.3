Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3LEXQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:16:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48648 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3LEXQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:16:06 -0500
Message-ID: <52A10932.1040903@wwwdotorg.org>
Date: Thu, 05 Dec 2013 16:16:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@linaro.org
CC: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, thierry.reding@gmail.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] ARM: tegra: add pinmux controller to tegra124.dtsi
References: <1386241070-4350-1-git-send-email-ldewangan@nvidia.com> <1386241070-4350-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1386241070-4350-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 03:57 AM, Laxman Dewangan wrote:
> The tegra124 pinmux controller is identical to tegra114 with
> removing some of existing pins from T114 and adding new pins.

I already sent this patch.

> diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi

> +	pinmux: pinmux {

Note that the rules for DT node naming have changed recently. Node name
must include a unit address if the node includes a reg property, and not
include a unit address otherwise. So, that should be:

+	pinmux: pinmux@70000868 {

The patch I sent already does that.
