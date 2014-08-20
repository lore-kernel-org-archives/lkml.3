Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaHTOzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:55:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47157 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaHTOy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:54:57 -0400
Message-ID: <53F4B663.90400@ti.com>
Date: Wed, 20 Aug 2014 20:23:23 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
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
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        alexandre torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH 2/5] phy: miphy28lp: Add MiPHY28lp header file for DT
 x Driver defines
References: <1407944075-8093-1-git-send-email-gabriel.fernandez@linaro.org> <1407944075-8093-3-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1407944075-8093-3-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 13 August 2014 09:04 PM, Gabriel FERNANDEZ wrote:
> This provides the shared header file which will be reference from both
> the MiPHY28lp driver and its associated Device Tree node(s).
> 
> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>  include/dt-bindings/phy/phy-miphy28lp.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>  create mode 100644 include/dt-bindings/phy/phy-miphy28lp.h
> 
> diff --git a/include/dt-bindings/phy/phy-miphy28lp.h b/include/dt-bindings/phy/phy-miphy28lp.h
> new file mode 100644
> index 0000000..7cf9bce
> --- /dev/null
> +++ b/include/dt-bindings/phy/phy-miphy28lp.h
> @@ -0,0 +1,12 @@
> +/*
> + * This header provides constants for the phy framework
> + * based on the STMicroelectronics miph28lp.
> + */
> +#ifndef _DT_BINDINGS_PHY_MIPHY28LP
> +#define _DT_BINDINGS_PHY_MIPHY28LP
> +
> +#define MIPHY_TYPE_SATA		1
> +#define MIPHY_TYPE_PCIE		2
> +#define MIPHY_TYPE_USB		3

I think we should create a common file for phy so that all user's need not
create a separate copy of the same thing.

Thanks
Kishon
