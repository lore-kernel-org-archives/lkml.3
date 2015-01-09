Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbbAINvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:51:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58830 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932353AbbAINvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:51:06 -0500
Date: Fri, 9 Jan 2015 13:50:45 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Wang <wstephen@codeaurora.org>
Cc: "jcliburn@gmail.com" <jcliburn@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
Message-ID: <20150109135045.GE12942@leverpostej>
References: <y>
 <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:03:46PM +0000, Stephen Wang wrote:
> This driver adds support for the internal GMACs on IPQ806x SoCs.
> It supports the device-tree and will register up to 4 ethernet
> interfaces.
> 
> Signed-off-by: Stephen Wang <wstephen@codeaurora.org>
> ---
>  drivers/net/ethernet/atheros/Kconfig               |   10 +
>  drivers/net/ethernet/atheros/Makefile              |    1 +
>  drivers/net/ethernet/atheros/nss-gmac/LICENSE.txt  |   14 +
>  drivers/net/ethernet/atheros/nss-gmac/Makefile     |   19 +
>  .../atheros/nss-gmac/exports/nss_gmac_api_if.h     |  126 ++
>  .../atheros/nss-gmac/include/msm_nss_gmac.h        |  338 ++++
>  .../atheros/nss-gmac/include/msm_nss_macsec.h      |   73 +
>  .../atheros/nss-gmac/include/nss_gmac_clocks.h     |  100 +
>  .../atheros/nss-gmac/include/nss_gmac_dev.h        | 2136 ++++++++++++++++++++
>  .../nss-gmac/include/nss_gmac_network_interface.h  |   63 +
>  .../net/ethernet/atheros/nss-gmac/nss_gmac_ctrl.c  | 1210 +++++++++++
>  .../net/ethernet/atheros/nss-gmac/nss_gmac_dev.c   | 1963 ++++++++++++++++++
>  .../ethernet/atheros/nss-gmac/nss_gmac_ethtool.c   |  526 +++++
>  .../net/ethernet/atheros/nss-gmac/nss_gmac_init.c  | 1131 +++++++++++
>  .../ethernet/atheros/nss-gmac/nss_gmac_mdiobus.c   |  187 ++
>  .../atheros/nss-gmac/nss_gmac_tx_rx_offload.c      | 1175 +++++++++++

Device tree bindings _must_ be documented, yet this standalone patch
adds nothing to Documentation/devicetree/bindings per the diffstat
above. So trivial NAK until there's a patch documenting that.

See Documentation/devicetree/bindings/submitting-patches.txt 

Thanks,
Mark.
