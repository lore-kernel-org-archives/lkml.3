Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3AaJhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:37:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39568 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3AaJhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:37:34 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>
Subject: RE: [PATCH v2 0/3] Add device tree support for NAND flash in
 am335x-evm
Thread-Topic: [PATCH v2 0/3] Add device tree support for NAND flash in
 am335x-evm
Thread-Index: AQHN+gkHtHC6EVLY202wwoalZaMh8phi2Jyg
Date: Thu, 31 Jan 2013 09:36:10 +0000
Deferred-Delivery: Thu, 31 Jan 2013 09:36:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA68A6D@DBDE01.ent.ti.com>
References: <cover.1359007746.git.avinashphilip@ti.com>
In-Reply-To: <cover.1359007746.git.avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On Thu, Jan 24, 2013 at 13:32:26, Philip, Avinash wrote:
> This patch series adds device tree support for NAND flash in am335x-evm.
> Also ELM node is populated in device tree and been used for BCH error
> correction in NAND flash part. Also this patch series ensures RBL ecc
> layout maintained in Linux kernel with BCH8 ecc scheme.
> 
> This patch series based on [1] and depends on [2].
> 
> 1. http://git.kernel.org/?p=linux/kernel/git/bcousson/linux-omap-dt.git;a=tree;h=refs/heads/for_3.9/dts;hb=refs/heads/for_3.9/dts
> 
> 2.mtd: devices: elm: Removes <xx> literals in elm DT node
>   https://lkml.org/lkml/2013/1/24/30
> 

Can you accept this patch series so that NAND flash with BCH support
for am335x-evm available in 3.9.

Thanks
Avinash


> Philip Avinash (1):
>   ARM: dts: AM33XX: Add NAND flash device tree data to am335x-evm
> 
> Philip, Avinash (2):
>   ARM: dts: AM33XX: Add ELM node
>   ARM: dts: AM33XX: Add GPMC node
> 
>  arch/arm/boot/dts/am335x-evm.dts |   98 +++++++++++++++++++++++++++++++++++++-
>  arch/arm/boot/dts/am33xx.dtsi    |   20 ++++++++
>  2 files changed, 117 insertions(+), 1 deletion(-)
> 
> -- 
> 1.7.9.5
> 
> 

