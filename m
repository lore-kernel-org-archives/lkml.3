Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbaGROY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:24:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:38534 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030531AbaGROYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:24:24 -0400
Message-ID: <53C92E15.4030702@atmel.com>
Date: Fri, 18 Jul 2014 16:24:21 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] ARM: at91: remove phy fixup for sama5d3xek boards
References: <1405022394-8311-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1405022394-8311-1-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 21:59, Boris BREZILLON :
> Hello,
> 
> This patch removes a board specific hook for sama5d3xek boards from the
> sama5d3 generic DT board file.
> 
> This hook (which register a phy fixup configuring board specific delays
> in the ksz9021 ethernet phy) is now replaced by the appropriate DT
> properties definitions in the sama5d3xcm.dtsi file.
> 
> Best Regards,

On the whole series:


Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> Changes since v2:
>  - define 2 phy nodes to handle Ronetix and Embest HW designs
> 
> Changes since v1:
>  - fix txc-skew-ps and rxc-skew-ps delays
>  - remove phy address info to handle Ronetix and Embest HW designs
> 
> Boris BREZILLON (2):
>   ARM: at91/dt: describe rgmii ethernet phy connected to sama5d3xek
>     boards
>   ARM: at91: remove phy fixup for sama5d3xek boards
> 
>  arch/arm/boot/dts/sama5d3xcm.dtsi   | 30 ++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/board-dt-sama5.c | 22 ----------------------
>  2 files changed, 30 insertions(+), 22 deletions(-)
> 


-- 
Nicolas Ferre
