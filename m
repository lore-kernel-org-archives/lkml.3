Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaHMMSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:18:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55310 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528AbaHMMSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:18:16 -0400
Date: Wed, 13 Aug 2014 13:18:14 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v2 2/2] mfd: arizona: Update DT binding to
	support INn_MODE init_data
Message-ID: <20140813121814.GI15833@opensource.wolfsonmicro.com>
References: <20140813205456.636abc68@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813205456.636abc68@songinha-Samsung-DeskTop-System>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 08:54:56PM +0900, Inha Song wrote:
> This patch update DT binding to support INn_MODE init_data. Each
> input signal path can be configurated either as a Analogue or
> Digital using the INn_MODE registers.
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 5c7e723..b8c131e 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -42,6 +42,14 @@ Optional properties:
>      the chip default will be used.  If present exactly five values must
>      be specified.
>  
> +  - wlf,inmode : A list of INn_MODE register values, where n is the number
> +    of input signal. Each input signal path can be configurated either as a
> +    Analogue or Digital using the INn_MODE registers. If absent, INn_MODE
> +    registers set to 0 by default. If present, values must be specified less
> +    than or equal to the number of input singal. If values less than the

Typo here should be "input signals".

> +    number of input signal, elements that has not been specifed are set to 0
> +    by default.
> +
>    - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
>      they are being externally supplied. As covered in
>      Documentation/devicetree/bindings/regulator/regulator.txt
> -- 
> 2.0.0.390.gcb682f8
> 

Thanks,
Charles
