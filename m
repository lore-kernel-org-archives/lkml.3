Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab3JQOlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:41:24 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:48109 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3JQOlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:41:23 -0400
MIME-Version: 1.0
In-Reply-To: <1382011756-24884-1-git-send-email-matt.porter@linaro.org>
References: <1382011756-24884-1-git-send-email-matt.porter@linaro.org>
Date: Thu, 17 Oct 2013 09:41:22 -0500
Message-ID: <CAL_JsqLM9__YUCZRy5_G3axd5zFNkUUaq9bU9VKHDriRDkKrEA@mail.gmail.com>
Subject: Re: [RESEND][PATCH] of: add vendor prefix for PHYTEC Messtechnik GmbH
From: Rob Herring <robherring2@gmail.com>
To: Matt Porter <matt.porter@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 7:09 AM, Matt Porter <matt.porter@linaro.org> wrote:
> Adds PHYTEC to the list of DT vendor prefixes.
>
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)

Applied.

Rob

>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 2956800..ddcd322 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -45,6 +45,7 @@ nintendo      Nintendo
>  nvidia NVIDIA
>  nxp    NXP Semiconductors
>  onnn   ON Semiconductor Corp.
> +phytec PHYTEC Messtechnik GmbH
>  picochip       Picochip Ltd
>  powervr        PowerVR (deprecated, use img)
>  qca    Qualcomm Atheros, Inc.
> --
> 1.8.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
