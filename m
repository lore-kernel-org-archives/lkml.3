Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaBFGtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 01:49:12 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:50816 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbaBFGtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 01:49:10 -0500
Date: Thu, 6 Feb 2014 11:55:54 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>, spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 4/8] phy: st-miphy-40lp: Add skeleton driver
Message-ID: <20140206062554.GB2394@pratyush-vbox>
References: <cover.1391661589.git.pratyush.anand@st.com>
 <8596e7596e0dfa9a487c4c2deb325bbdf785e55e.1391661589.git.pratyush.anand@st.com>
 <52F32549.5010303@ti.com>
 <20140206061430.GA2394@pratyush-vbox>
 <52F32A58.1000904@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52F32A58.1000904@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 02:23:20PM +0800, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Thursday 06 February 2014 11:44 AM, Pratyush Anand wrote:
> > Hi Kishon,
> > 
> > On Thu, Feb 06, 2014 at 02:01:45PM +0800, Kishon Vijay Abraham I wrote:
> >> Hi,
> >>
> >> On Thursday 06 February 2014 10:14 AM, Pratyush Anand wrote:
> >>> ST miphy-40lp supports PCIe, SATA and Super Speed USB. This driver adds

[...]

> >>> +
> >>> +	phy_provider = devm_of_phy_provider_register(dev, st_miphy40lp_xlate);
> >>> +	if (IS_ERR(phy_provider)) {
> >>> +		dev_err(dev, "failed to register phy provider\n");
> >>> +		return PTR_ERR(phy_provider);
> >>> +	}
> >>
> >> phy_provider_register should be the last step in registering the PHY. Or your
> >> PHY call backs can be called before you create the PHY. Btw in your case you
> > 
> > But every one else like  phy-exynos-mipi-video or phy-omap-usb2 or any
> > other did it same way. First phy_provider_register and then
> > phy_create.
> 
> That's a bug which we figured out very late. Will get it fixed in this -rc cycle.

Ok..I ll correct in mine too. :)

Rgds
Pratyush
> 
> Thanks
> Kishon
