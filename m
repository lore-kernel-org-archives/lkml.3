Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3COVBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:01:34 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56977 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab3COVBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:01:33 -0400
Message-ID: <51438C2A.9000302@free-electrons.com>
Date: Fri, 15 Mar 2013 22:01:30 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, sunny@allwinnertech.com,
        shuge@allwinnertech.com, Stefan Roese <sr@denx.de>,
        kevin@allwinnertech.com
Subject: Re: [PATCH 1/5] net: Add davicom wemac ethernet driver found on Allwinner
 A10 SoC's
References: <1363380605-6577-1-git-send-email-maxime.ripard@free-electrons.com> <1363380605-6577-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1363380605-6577-2-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/03/2013 21:50, Maxime Ripard a écrit :
> From: Stefan Roese <sr@denx.de>
> 
> The Allwinner A10 has an ethernet controller that is advertised as
> coming from Davicom.
> 
> The exact feature set of this controller is unknown, since there is no
> public documentation for this IP, and this driver is mostly the one
> published by Allwinner that has been heavily cleaned up.
> 
> Signed-off-by: Stefan Roese <sr@denx.de>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../devicetree/bindings/net/davicom-wemac.txt      |   20 +
>  drivers/net/ethernet/Makefile                      |    2 +-
>  drivers/net/ethernet/davicom/Kconfig               |   31 +
>  drivers/net/ethernet/davicom/Makefile              |    1 +
>  drivers/net/ethernet/davicom/wemac.c               | 1033 ++++++++++++++++++++
>  drivers/net/ethernet/davicom/wemac.h               |  130 +++
>  6 files changed, 1216 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom-wemac.txt
>  create mode 100644 drivers/net/ethernet/davicom/wemac.c
>  create mode 100644 drivers/net/ethernet/davicom/wemac.h
> 
> diff --git a/Documentation/devicetree/bindings/net/davicom-wemac.txt b/Documentation/devicetree/bindings/net/davicom-wemac.txt
> new file mode 100644
> index 0000000..516cf31
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/davicom-wemac.txt
> @@ -0,0 +1,20 @@
> +* Marvell Armada 370 / Armada XP Ethernet Controller (NETA)
> +
> +Required properties:
> +- compatible: should be "marvell,armada-370-neta".

It looks like I've been a bit too quick to send this one... I'll change
in v2, obviously.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
