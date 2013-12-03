Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3LCGGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 01:06:55 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9395 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3LCGGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 01:06:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Dec 2013 22:03:58 -0800
Message-ID: <529D745D.2070503@nvidia.com>
Date: Tue, 3 Dec 2013 11:34:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: tegra: Header file for pinctrl constants
References: <1385992502-12771-1-git-send-email-ldewangan@nvidia.com> <20131202142522.GA17566@ulmo.nvidia.com>
In-Reply-To: <20131202142522.GA17566@ulmo.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 December 2013 07:55 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Mon, Dec 02, 2013 at 07:25:01PM +0530, Laxman Dewangan wrote:
>

> +
> +/* Schmitt enable/disable */
> +#define TEGRA_PIN_DRIVE_SCHMITT_DISABLE			0
> +#define TEGRA_PIN_DRIVE_SCHMITT_ENABLE			1
> These are all boolean, so I wonder if perhaps we should be simply
> defining a single pair and reuse that in different contexts:
>
> 	#define TEGRA_PIN_DISABLE	0
> 	#define TEGRA_PIN_ENABLE	1
>
> The property names should provide enough context for them to be used
> unambiguously.
>
>

I can make generic ENABLE/DISABLE macro as you suggested but datasheet 
says as 0=NORMAL, 1 = TRISTATE. and that's why I kept name very near to 
the datasheet.

Thanks,
Laxman
