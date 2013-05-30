Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965429Ab3E3RYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:24:25 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34721 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965043Ab3E3RYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:24:19 -0400
Message-ID: <51A78B45.1060604@cogentembedded.com>
Date: Thu, 30 May 2013 21:24:21 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Ralf Baechle <ralf@linux-mips.org>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 4/6] MIPS: jz4740: Register jz4740 DMA device
References: <1369931105-28065-1-git-send-email-lars@metafoo.de> <1369931105-28065-5-git-send-email-lars@metafoo.de>
In-Reply-To: <1369931105-28065-5-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/30/2013 08:25 PM, Lars-Peter Clausen wrote:

> Register a device for the newly added jz4740 dmaengine driver.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
[...]
>   3 files changed, 23 insertions(+)
> diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
> index e9348fd..35a9d8c 100644
> --- a/arch/mips/jz4740/platform.c
> +++ b/arch/mips/jz4740/platform.c
> @@ -329,3 +329,24 @@ struct platform_device jz4740_pwm_device = {
[...]
> +struct platform_device jz4740_dma_device = {
> +	.name	= "jz4740-dma",
> +	.id	= -1,

    Why not align all = in this structure?

> +	.num_resources = ARRAY_SIZE(jz4740_dma_resources),
> +	.resource      = jz4740_dma_resources,
> +};

