Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaCEHgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:36:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65481 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbaCEHgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:36:12 -0500
Date: Wed, 5 Mar 2014 07:35:44 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 2/4] phy: miphy365x: Add MiPHY365x header file for DT x
 Driver defines
Message-ID: <20140305073544.GE20016@e106331-lin.cambridge.arm.com>
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
 <1392377036-12816-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392377036-12816-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:23:54AM +0000, Lee Jones wrote:
> This provides the shared header file which will be reference from both
> the MiPHY365x driver and its associated Device Tree node(s).
> 
> Cc: devicetree@vger.kernel.org
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/dt-bindings/phy/phy-miphy365x.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 include/dt-bindings/phy/phy-miphy365x.h

Given this defines part of the binding, it should probably go in the
same patch.

Cheers,
Mark.

> 
> diff --git a/include/dt-bindings/phy/phy-miphy365x.h b/include/dt-bindings/phy/phy-miphy365x.h
> new file mode 100644
> index 0000000..8757c02
> --- /dev/null
> +++ b/include/dt-bindings/phy/phy-miphy365x.h
> @@ -0,0 +1,25 @@
> +/*
> + * This header provides constants for the phy framework
> + * based on the STMicroelectronics miphy365x.
> + */
> +#ifndef _DT_BINDINGS_PHY_MIPHY
> +#define _DT_BINDINGS_PHY_MIPHY
> +
> +/* Supports 16 ports without a datatype change (u8 & 0xF0). */
> +#define MIPHY_PORT_0			0
> +#define MIPHY_PORT_1			1
> +#define MIPHY_PORT_2			2
> +#define MIPHY_PORT_3			3
> +
> +/* Supports 16 types without a datatype change (u8 & 0x0F). */
> +#define MIPHY_TYPE_SHIFT		4
> +#define MIPHY_TYPE_SATA			(0 << MIPHY_TYPE_SHIFT)
> +#define MIPHY_TYPE_PCIE			(1 << MIPHY_TYPE_SHIFT)
> +#define MIPHY_TYPE_USB			(2 << MIPHY_TYPE_SHIFT)
> +
> +#define MIPHY_SATA_PORT0		(MIPHY_TYPE_SATA) | (MIPHY_PORT_0)
> +#define MIPHY_SATA_PORT1		(MIPHY_TYPE_SATA) | (MIPHY_PORT_1)
> +#define MIPHY_PCIE_PORT0		(MIPHY_TYPE_PCIE) | (MIPHY_PORT_0)
> +#define MIPHY_PCIE_PORT1		(MIPHY_TYPE_PCIE) | (MIPHY_PORT_1)
> +
> +#endif /* _DT_BINDINGS_PHY_MIPHY */
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
