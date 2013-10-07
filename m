Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3JGN6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 09:58:49 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5876 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab3JGN6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 09:58:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Oct 2013 06:58:46 -0700
Message-ID: <5252C3E1.5010509@nvidia.com>
Date: Mon, 7 Oct 2013 19:53:29 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] clk: palmas: add clock driver for palmas
References: <1381154751-4565-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1381154751-4565-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 October 2013 07:35 PM, Laxman Dewangan wrote:
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -43,3 +43,5 @@ obj-$(CONFIG_COMMON_CLK_SI5351) += clk-si5351.o
>   obj-$(CONFIG_COMMON_CLK_S2MPS11) += clk-s2mps11.o
>   obj-$(CONFIG_CLK_TWL6040)	+= clk-twl6040.o
>   obj-$(CONFIG_CLK_PPC_CORENET)	+= clk-ppc-corenet.o
> +obj-$(CONFIG_COMMON_CLK_PALMAS)	+= clk-palmas.o
> +obj-y += clk-test.o
>

Sorry, silly mistake, the line

+obj-y += clk-test.o

is not require. This was done for testing only.

I will respin the patch but wait for some more feedback if any to add on 
next version.

Thanks,
Laxman

