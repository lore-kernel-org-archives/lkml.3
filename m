Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaFWNHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:07:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48486 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932132AbaFWNFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:34 -0400
Date: Mon, 23 Jun 2014 15:05:19 +0200
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
Subject: Re: [PATCH v6 1/7] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140623130519.GA23540@kwain>
References: <1402914392-6028-1-git-send-email-antoine.tenart@free-electrons.com>
 <1402914392-6028-2-git-send-email-antoine.tenart@free-electrons.com>
 <53A0861E.90400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A0861E.90400@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Tue, Jun 17, 2014 at 08:17:02PM +0200, Sebastian Hesselbarth wrote:
> On 06/16/2014 12:26 PM, Antoine Ténart wrote:
> > +
> > +#define PHY_BASE		0x200
> 
> Antoine,
> 
> I gave your Berlin AHCI patches a try on BG2. I finally got it working
> but BG2 has a different PHY_BASE and need some register fixups.
> 
> Please update this patch and the DT bindings to reflect the difference
> of BG2Q with respect to BG2 as below.
> 
> [...]
> > +
> > +static const struct of_device_id phy_berlin_sata_of_match[] = {
> > +	{ .compatible = "marvell,berlin-sata-phy" },
> 
> s/marvell,berlin-sata-phy/marvell,berlin2-sata-phy/
> 
> and add
> 
> marvell,berlin2q-sata-phy
> 
> That way it can be applied now without proper support for BG2
> and I can send patches later.

Sure. I'll just s/marvell,berlin-sata-phy/marvell,berlin2q-sata-phy/ so
we don't have a non working compatible.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
