Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaIWOlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:41:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58458 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753709AbaIWOlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:41:23 -0400
Date: Tue, 23 Sep 2014 16:41:18 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] Documentation: bindings: net: add the Marvell
 PXA168 Ethernet controller
Message-ID: <20140923144118.GF18924@kwain>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com>
 <51745791.Wuu5QiQB2e@wuerfel>
 <20140923140113.GC18924@kwain>
 <3708177.kEGF9Dk44n@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3708177.kEGF9Dk44n@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:33:48PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 16:01:13 Antoine Tenart wrote:
> > 
> > On Tue, Sep 23, 2014 at 02:38:39PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 23 September 2014 14:15:30 Antoine Tenart wrote:
> > > > +Optional properties:
> > > > +- port-id: should be '0','1' or '2'.
> > > > +- phy-addr: MDIO address of the PHY.
> > > > +- local-mac-address: see ethernet.txt file in the same directory.
> > > > +
> > > > 
> > > 
> > > I believe new bindings should not use "phy-addr" properties, but
> > > instead use a phy-handle property pointing to a phy device instead.
> > 
> > That's the MDIO address of the PHY. It's a bit difficult to use a phy
> > device as the driver uses the libphy. And that would break the platform
> > using it.
> > 
> > Or maybe you have something in mind?
> 
> I don't understand what you mean. Doesn't libphy imply using a phy_device?
> What I meant was that you should be able to just call the standard
> of_phy_connect() and other interfaces to deal with phylib.
> 

Yes sure, I read again my answer and... well I should have had a better
look on the matter.

Anyway, as the proposed binding seems to be OK with you, I'll update the
series accordingly.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
