Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbaGYLfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:35:40 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47715 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaGYLfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:35:38 -0400
Message-ID: <53D240B3.8060203@gmail.com>
Date: Fri, 25 Jul 2014 17:04:11 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nicolin Chen <nicoleotsuka@gmail.com>, broonie@kernel.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, timur@tabi.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        shawn.guo@linaro.org, b02247@freescale.com, b42378@freescale.com,
        tklauser@distanz.ch
Subject: Re: [PATCH v5 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform
 drivers
References: <cover.1406276436.git.nicoleotsuka@gmail.com> <2288e61e600e28448905e32dd4f74a954110248f.1406276436.git.nicoleotsuka@gmail.com>
In-Reply-To: <2288e61e600e28448905e32dd4f74a954110248f.1406276436.git.nicoleotsuka@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 02:16 PM, Nicolin Chen wrote:
> The Asynchronous Sample Rate Converter (ASRC) converts the sampling rate of a
> signal associated with an input clock into a signal associated with a different
> output clock. The driver currently works as a Front End of DPCM with other Back
> Ends DAI links such as ESAI<->CS42888 and SSI<->WM8962 and SAI. It converts the
> original sample rate to a common rate supported by Back Ends for playback while
> converts the common rate of Back Ends to a desired rate for capture. It has 3
> pairs to support three different substreams within totally 10 channels.
>
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> ---
>   .../devicetree/bindings/sound/fsl,asrc.txt         |  60 ++
>   sound/soc/fsl/Kconfig                              |   9 +
>   sound/soc/fsl/Makefile                             |   2 +
>   sound/soc/fsl/fsl_asrc.c                           | 992 +++++++++++++++++++++
>   sound/soc/fsl/fsl_asrc.h                           | 461 ++++++++++
>   sound/soc/fsl/fsl_asrc_dma.c                       | 386 ++++++++
>   6 files changed, 1910 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/sound/fsl,asrc.txt
>   create mode 100644 sound/soc/fsl/fsl_asrc.c
>   create mode 100644 sound/soc/fsl/fsl_asrc.h
>   create mode 100644 sound/soc/fsl/fsl_asrc_dma.c
>
>
check patch warnings on this patch...

-- 
Regards,
Varka Bhadram.

