Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaIXI4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:56:32 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:49352 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaIXI41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:56:27 -0400
Date: Wed, 24 Sep 2014 09:56:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] DT: mfd: pm8xxx: Add new compatible string
Message-ID: <20140924085621.GJ17801@lee--X1>
References: <1411480360-18091-1-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411480360-18091-1-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Stanimir Varbanov wrote:

> The rtc driver now supports PM8941 PMIC device, reflect this
> in the binding document.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
>  .../devicetree/bindings/mfd/qcom,pm8xxx.txt        |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied, thanks.

> diff --git a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
> index 03518dc..f24f334 100644
> --- a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
> +++ b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
> @@ -61,6 +61,7 @@ The below bindings specify the set of valid subnodes.
>  	Definition: must be one of:
>  		    "qcom,pm8058-rtc"
>  		    "qcom,pm8921-rtc"
> +		    "qcom,pm8941-rtc"
>  
>  - reg:
>  	Usage: required

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
