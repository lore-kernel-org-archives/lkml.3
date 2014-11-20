Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaKTI4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:56:40 -0500
Received: from smtp-out-061.synserver.de ([212.40.185.61]:1078 "EHLO
	smtp-out-060.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751161AbaKTI4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:56:39 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16503
Message-ID: <546DACC2.702@metafoo.de>
Date: Thu, 20 Nov 2014 09:56:34 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Zidan Wang <b50113@freescale.com>, broonie@kernel.org
CC: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH v2 1/2] ASoC: wm8960: Add device tree support
References: <1416472878-12108-1-git-send-email-b50113@freescale.com>
In-Reply-To: <1416472878-12108-1-git-send-email-b50113@freescale.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 09:41 AM, Zidan Wang wrote:
[...][
> +Optional properties:
> +  - shared_lrclk: This is a boolean property. If present, the LRCM bit of
> +	R24 (Additional control 2 ) gets set, indicating that ADCLRC and DACLRC
> +	will be disabled only when ADC (Left and Right) and DAC (Left and Right)
> +	are disabled.
> +
> +  - capless: This is a boolean property. If present, OUT3 will be enabled
> +	and disabled together with HP_L and HP_R in response to jack detect events.


Custom properties need a vendor prefix and properties should use '-' instead 
of '_'. Also the devicetree describes the hardware and not the driver, so 
the description should say for which hardware setups this flag should be 
set, not what the behavior of the driver will be.

- Lars

