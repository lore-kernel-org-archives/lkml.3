Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbbA1CIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:08:23 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48583 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933667AbbA1CIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:08:21 -0500
Message-ID: <54C8440F.3090906@free-electrons.com>
Date: Tue, 27 Jan 2015 23:06:07 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: linux-mtd@lists.infradead.org, Boris Brezillon <boris@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>, linux-kernel@vger.kernel.org,
        Sudhakar Gundubogula <sudhakar@marvell.com>,
        Seif Mazareeb <seif@marvell.com>
Subject: Re: [PATCH v2 2/2] ARM: mvebu: a385-db-ap: Enable the NAND
References: <1422284164-16867-1-git-send-email-maxime.ripard@free-electrons.com> <1422284164-16867-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1422284164-16867-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 11:56 AM, Maxime Ripard wrote:
> The Armada 385 Access Point Development Board has a 1GB NAND SLC chip from
> Micron as its main storage. Enable it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/armada-385-db-ap.dts | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/armada-385-db-ap.dts b/arch/arm/boot/dts/armada-385-db-ap.dts
> index b891b4c897f5..ee648fb19075 100644
> --- a/arch/arm/boot/dts/armada-385-db-ap.dts
> +++ b/arch/arm/boot/dts/armada-385-db-ap.dts
> @@ -130,6 +130,19 @@
>  				phy-mode = "rgmii-id";
>  			};
>  
> +			nfc: flash@d0000 {

I don't think you need to have this phandle here.

In any case, for both patches:

Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
