Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3LEUI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:08:59 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:57716 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3LEUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:08:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 1/2] regulator: gpio: Document regulator-type property
Date: Thu, 05 Dec 2013 21:08:59 +0100
Message-ID: <2371962.Qn6eVMpFgi@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1386270722-13962-1-git-send-email-broonie@kernel.org>
References: <1386270722-13962-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thank you for the patch.

On Thursday 05 December 2013 19:12:01 Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  Documentation/devicetree/bindings/regulator/gpio-regulator.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt index
> 63c659800c03..aaf5f66e66fb 100644
> --- a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> +++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> @@ -10,6 +10,8 @@ Optional properties:
>  - gpios			: GPIO group used to control voltage.
>  - startup-delay-us	: Startup time in microseconds.
>  - enable-active-high	: Polarity of GPIO is active high (default is low).
> +- regulator-type	: Specifies what is being regulated, must be either
> +			  "voltage" or "current"

What about adding "The type defaults to voltage if unspecified." ?

>  Any property defined as part of the core regulator binding defined in
>  regulator.txt can also be used.

-- 
Regards,

Laurent Pinchart

