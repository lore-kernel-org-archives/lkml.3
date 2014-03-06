Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaCFULS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:11:18 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20357 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752053AbaCFULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:11:14 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19oYlostkC5kuRbB9lMjnaS2GW+KczYl2c=
X-DKIM: OpenDKIM Filter v2.0.1 titan C10CF53C1FE
Date: Thu, 6 Mar 2014 15:10:59 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: mvebu: add Device Tree for the Armada 385 RD
 board
Message-ID: <20140306201059.GI1872@titan.lakedaemon.net>
References: <1394119075-18657-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394119075-18657-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 04:17:55PM +0100, Gregory CLEMENT wrote:
> The Armada 385 RD board is the reference design board from Marvell
> for the Armada 385 SoC. This commit adds a Device Tree description for
> this board, which enables the following features:
> 
>  * Network interfaces
>  * I2C bus
>  * Serial port
>  * SPI bus, with a SPI flash
>  * PCIe interface
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
> Changelog:
> v1 -> v2:
> 
> - used the phy-mode "rgmii-id" to be able to work with the Marvell PHY
>   driver enabled
> 
> - put the ethernet nodes in the address order, as it has no effect to
>   change ti at this level (should be done at dtsi level)
> 
> - inverted the phy devices (which was improperly assigned in v1)
> 
> - added the vendor prefix for the SPI flash
> 
> 
>  arch/arm/boot/dts/Makefile          |  3 +-
>  arch/arm/boot/dts/armada-385-rd.dts | 94 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 96 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/armada-385-rd.dts

Applied to mvebu/dt

thx,

Jason.
