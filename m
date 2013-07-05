Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab3GERiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:38:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33085 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab3GERiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:38:14 -0400
Message-ID: <51D70483.70203@wwwdotorg.org>
Date: Fri, 05 Jul 2013 11:38:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: acourbot@nvidia.com, linux@arm.linux.org.uk, MLongnecker@nvidia.com,
        linux-arm-kernel@lists.infradead.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dt: t30 cardhu: add dt entry for lm90
References: <1372928979-26938-1-git-send-email-wni@nvidia.com> <1372928979-26938-2-git-send-email-wni@nvidia.com>
In-Reply-To: <1372928979-26938-2-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 03:09 AM, Wei Ni wrote:
> Enable thermal sensor lm90 for t30 cardhu.

> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi

> +		nct1008: nct1008 {
> +			compatible = "lm90,nct1008";

"lm90" isn't a valid vendor prefix. I believe the value you want is
"onnn,nct1008". Same comment for patch 2/2.
