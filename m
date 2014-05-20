Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaETJXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:23:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58612 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbaETJXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:23:11 -0400
Date: Tue, 20 May 2014 11:23:07 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org, kishon@ti.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/7] ata: ahci_platform: add the Marvell Berlin AHCI
 compatible
Message-ID: <20140520092307.GA26491@kwain>
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
 <1400576675-25265-5-git-send-email-antoine.tenart@free-electrons.com>
 <537B1DD3.2040104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537B1DD3.2040104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:18:11AM +0200, Sebastian Hesselbarth wrote:
> On 05/20/2014 11:04 AM, Antoine Ténart wrote:
> >The Marvell Berlin AHCI has all his specific in the PHY driver. It then
> >only need to use the libahci functions to work properly.
> 
> If it is that generic, ..
> 
> >Add its compatible into the libahci_platform driver.
> >
> >Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> >---
> >  drivers/ata/ahci_platform.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> >index ef67e79944f9..bc050aabf206 100644
> >--- a/drivers/ata/ahci_platform.c
> >+++ b/drivers/ata/ahci_platform.c
> >@@ -76,6 +76,7 @@ static const struct of_device_id ahci_of_match[] = {
> >  	{ .compatible = "snps,exynos5440-ahci", },
> >  	{ .compatible = "ibm,476gtr-ahci", },
> >  	{ .compatible = "snps,dwc-ahci", },
> >+	{ .compatible = "marvell,berlin-ahci", },
> 
> .. why have a Marvell-specific compatible?

Well, the 3 other compatibles seemed as generic as the marvell one. Just
following what was done before here.

> How about "generic-ahci" instead, like we have for other fooHCIs
> already?

That would avoid an endless list of compatibles :)

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
