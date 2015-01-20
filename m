Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbbATMUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:20:14 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50847 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbATMUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:20:12 -0500
Date: Tue, 20 Jan 2015 12:20:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel] [PATCH v2 RESEND 2/2] mfd: arizona: Update DT
 binding to support OUTn_MONO init_data
Message-ID: <20150120122005.GA13701@x1>
References: <1420185829-24886-1-git-send-email-ideal.song@samsung.com>
 <1420185829-24886-3-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420185829-24886-3-git-send-email-ideal.song@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Jan 2015, Inha Song wrote:

> This patch update DT binding to support OUTn_MONO init_data. Each
> output signal can be configurated as a mono differential output.
> The mono differential configuration is selected using the OUTn_MONO
> registers.

This requires a DT Ack and an entry in the example.

> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 7bd1273..cf11d42 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -49,6 +49,13 @@ Optional properties:
>      input singals. If values less than the number of input signals, elements
>      that has not been specifed are set to 0 by default.
>  
> +  - wlf,out-mono : A list of OUTn_MONO register values, where n is the number
> +    of output signals. Valid values are 0 (Disabled) and 1 (Enabled). If absent,
> +    OUTn_MONO registers set to 0 by default. If present, values must be specified
> +    less than or equal to the number of output signals. If values less than the
> +    number of input signals, elements that has not been specified are set to 0
> +    by default.
> +
>    - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
>      they are being externally supplied. As covered in
>      Documentation/devicetree/bindings/regulator/regulator.txt

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
