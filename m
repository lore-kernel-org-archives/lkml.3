Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaFWIQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:16:04 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33646 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaFWIQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:16:00 -0400
Date: Mon, 23 Jun 2014 09:15:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] Documentation: devicetree: Fix s2mps11 example syntax
Message-ID: <20140623081553.GB8847@lee--X1>
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>
 <1403486483-4063-3-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403486483-4063-3-git-send-email-afaerber@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014, Andreas Färber wrote:

> It's <1>, not 1.
> 
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> index 55ab4f4..99a0c52 100644
> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -96,7 +96,7 @@ Example:
>  
>  		s2m_osc: clocks {
>  			compatible = "samsung,s2mps11-clk";
> -			#clock-cells = 1;
> +			#clock-cells = <1>;
>  			clock-output-names = "xx", "yy", "zz";
>  		};
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
