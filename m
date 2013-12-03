Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3LCUGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:06:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41320 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3LCUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:06:46 -0500
Message-ID: <529E39D2.9000705@wwwdotorg.org>
Date: Tue, 03 Dec 2013 13:06:42 -0700
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

> +/* Pull up/down/normal */
> +#define TEGRA_PIN_PUPD_NORMAL				0
> +#define TEGRA_PIN_PUPD_PULL_DOWN			1
> +#define TEGRA_PIN_PUPD_PULL_UP				2

... and s/NORMAL/NONE/ here too, I think. Some people might consider
some other value e.g. pull-up as normal:-)
