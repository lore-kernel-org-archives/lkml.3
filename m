Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3LDRDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:03:41 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43853 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3LDRDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:03:37 -0500
Message-ID: <529F6064.3010300@wwwdotorg.org>
Date: Wed, 04 Dec 2013 10:03:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com
CC: pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] ARM: tegra: Add header file for pinctrl constants
References: <1386076567-14283-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1386076567-14283-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 06:16 AM, Laxman Dewangan wrote:
> This new header file defines pincontrol constants for Tegra to
> use from Tegra's DTS file for pincontrol properties option.

> diff --git a/include/dt-bindings/pinctrl/pinctrl-tegra.h b/include/dt-bindings/pinctrl/pinctrl-tegra.h

> +#define TEGRA_PIN_DISABLE				0
> +#define TEGRA_PIN_ENABLE				1

That needs a comment re: which properties the defines can be used with,
since the properties are no longer related to the defines by name.

> +/* Pull up/down/normal */
> +#define TEGRA_PIN_PULL_NONE				0
> +#define TEGRA_PIN_PULL_DOWN				1
> +#define TEGRA_PIN_PULL_UP				2

Whereas that comment seems unnecessary, since it's obvious from the
define names.

> +/* Low power mode */
> +#define TEGRA_PIN_LP_DRIVE_DIV_8			0
> +#define TEGRA_PIN_LP_DRIVE_DIV_4			1
> +#define TEGRA_PIN_LP_DRIVE_DIV_2			2
> +#define TEGRA_PIN_LP_DRIVE_DIV_1			3

