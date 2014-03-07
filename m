Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaCGKuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:50:39 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:37292 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbaCGKui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:50:38 -0500
Message-ID: <5319A2D2.7090700@st.com>
Date: Fri, 7 Mar 2014 10:43:30 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime COQUELIN <maxime.coquelin@st.com>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>
Cc: <lee.jones@linaro.org>
Subject: Re: [PATCH v2 2/5] pinctrl: st: add pinctrl support for the STiH407
 SoC
References: <1394185272-26054-1-git-send-email-maxime.coquelin@st.com> <1394185272-26054-3-git-send-email-maxime.coquelin@st.com>
In-Reply-To: <1394185272-26054-3-git-send-email-maxime.coquelin@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peppe/Maxime,
On 07/03/14 09:41, Maxime COQUELIN wrote:
> From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> 
> This patch adds the initial support for pinctrl based on H407 SoC.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  drivers/pinctrl/pinctrl-st.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 9fb66aa..9e9b6ea 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1580,6 +1580,10 @@ static struct of_device_id st_pctl_of_match[] = {
>  	{ .compatible = "st,stih416-rear-pinctrl", .data = &stih416_data},
>  	{ .compatible = "st,stih416-fvdp-fe-pinctrl", .data = &stih416_data},
>  	{ .compatible = "st,stih416-fvdp-lite-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stih407-sbc-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stih407-front-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stih407-rear-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stih407-flash-pinctrl", .data = &stih416_data},
In the follow on patch this is changed to stih407_flashdata.

Why should this not be done in this patch itself.
>  	{ /* sentinel */ }
>  };
>  
Other than that the patch looks Ok to me.

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Thanks,
srini
> 

