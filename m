Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbaKFHAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:00:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55427 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaKFHAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:00:39 -0500
Message-ID: <545B1C53.9010406@ti.com>
Date: Thu, 6 Nov 2014 12:29:31 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH v5 2/8] phy: miphy28lp: Add PHY header file for DT x Driver
 defines
References: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org> <1415098284-11182-3-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1415098284-11182-3-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 04 November 2014 04:21 PM, Gabriel FERNANDEZ wrote:
> This provides the shared header file which will be reference from both
> PHY driver and its associated Device Tree node(s).
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>  include/dt-bindings/phy/phy.h | 18 ++++++++++++++++++

I don't see this being used in device tree file. Are you planning to add this
after -rc1 is tagged. Or else I have to create a separate branch for this file
which will be merged by both me and the dt maintainer. Let me know.

Thanks
Kishon
>  1 file changed, 18 insertions(+)
>  create mode 100644 include/dt-bindings/phy/phy.h
> 
> diff --git a/include/dt-bindings/phy/phy.h b/include/dt-bindings/phy/phy.h
> new file mode 100644
> index 0000000..e8c6a3f
> --- /dev/null
> +++ b/include/dt-bindings/phy/phy.h
> @@ -0,0 +1,18 @@
> +/*
> + *
> + * This header provides constants for the phy framework
> + *
> + * Copyright (C) 2014 STMicroelectronics
> + * Author: Gabriel Fernandez <gabriel.fernandez@st.com>
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef _DT_BINDINGS_PHY
> +#define _DT_BINDINGS_PHY
> +
> +#define PHY_TYPE_SATA		1
> +#define PHY_TYPE_PCIE		2
> +#define PHY_TYPE_USB2		3
> +#define PHY_TYPE_USB3		4
> +
> +#endif /* _DT_BINDINGS_PHY */
> 
