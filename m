Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaFESmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:42:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58192 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaFESl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:41:58 -0400
Message-ID: <5390B9F3.8030108@wwwdotorg.org>
Date: Thu, 05 Jun 2014 12:41:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/5] ARM: tegra: Add efuse and apbmisc bindings
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com> <1401973754-19701-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401973754-19701-5-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 07:09 AM, Peter De Schrijver wrote:
> Add efuse and apbmisc bindings for Tegra20, Tegra30, Tegra114 and Tegra124.

> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi

> +	apbmisc@70000800 {
> +		compatible = "nvidia,tegra114-apbmisc", "nvidia,tegra20-apbmisc";

Is the Tegra114 APBMISC register layout 100% a backwards-compatible
superset of that in Tegra20? For both registers the code currently uses
*and* all possible registers the code could ever use? Since the APB MISC
is a bit of a dumping ground for random registers, that feels unlikely,
but perhaps it's possible.
