Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3LEXTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:19:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54987 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3LEXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:19:51 -0500
Message-ID: <52A10A13.2020608@wwwdotorg.org>
Date: Thu, 05 Dec 2013 16:19:47 -0700
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
References: <1386241070-4350-1-git-send-email-ldewangan@nvidia.com> <1386241070-4350-3-git-send-email-ldewangan@nvidia.com> <52A10932.1040903@wwwdotorg.org>
In-Reply-To: <52A10932.1040903@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 04:16 PM, Stephen Warren wrote:
> On 12/05/2013 03:57 AM, Laxman Dewangan wrote:
>> The tegra124 pinmux controller is identical to tegra114 with
>> removing some of existing pins from T114 and adding new pins.
> 
> I already sent this patch.

Oh, I do notice one difference between the two patches:

Mine:

> +		reg = <0x70000868 0x148>,	/* Pad control registers */
> +		      <0x70003000 0x40c>;	/* Mux registers */

Yours:

> +		reg = <0x70000868 0x164		/* Pad control registers */
> +		       0x70003000 0x434>;	/* PinMux registers */

Are the increase register lengths in your patch correct? If so, I guess
I'll drop my patch and replace it with yours if you fix up the unit address.
