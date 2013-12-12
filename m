Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3LLShG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:37:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45358 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3LLShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:37:03 -0500
Message-ID: <52AA024B.20409@wwwdotorg.org>
Date: Thu, 12 Dec 2013 11:36:59 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@linaro.org
CC: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, thierry.reding@gmail.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: tegra: select PINCTRL_TEGRA124 for Tegra124
 SoC
References: <1386241070-4350-1-git-send-email-ldewangan@nvidia.com> <1386241070-4350-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1386241070-4350-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 03:57 AM, Laxman Dewangan wrote:
> The pincontrol driver for Tegra124 is build through config
> PINCTRL_TEGRA124. Select this config option whenever Tegra124
> SoC is enabled.

Applied to Tegra's for-3.14/soc branch.

(I thought I had sent this before myself, but I'd only written the patch
locally, and had not actually sent it out, hence I took your identical
patch.)
