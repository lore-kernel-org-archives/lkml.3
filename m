Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3LCUFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:05:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52277 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab3LCUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:05:44 -0500
Message-ID: <529E3995.8090606@wwwdotorg.org>
Date: Tue, 03 Dec 2013 13:05:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com
CC: pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: tegra: Header file for pinctrl constants
References: <1385992502-12771-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1385992502-12771-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 06:55 AM, Laxman Dewangan wrote:
> Defines pincontrol constants to use from Tegra's DTS file
> for tegra pincontrol properties option.

> diff --git a/include/dt-bindings/pinctrl/pinctrl-tegra.h b/include/dt-bindings/pinctrl/pinctrl-tegra.h

> +/* Tristate/normal */
> +#define TEGRA_PIN_NORMAL				0
> +#define TEGRA_PIN_TRISTATE				1

"NORMAL" is a bit generic. "DRIVEN" might work better.

> +/* High speed mode */
> +#define TEGRA_PIN_DRIVE_HIGH_SPEED_MODE_DISABLE		0
> +#define TEGRA_PIN_DRIVE_HIGH_SPEED_MODE_ENABLE		1
> +
> +/* Schmitt enable/disable */
> +#define TEGRA_PIN_DRIVE_SCHMITT_DISABLE			0
> +#define TEGRA_PIN_DRIVE_SCHMITT_ENABLE			1

I expect you can remove "DRIVE_" from all those names to make things
shorter.
