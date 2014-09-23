Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaIWOBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:01:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57919 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754373AbaIWOBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:01:17 -0400
Date: Tue, 23 Sep 2014 16:01:13 +0200
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
Message-ID: <20140923140113.GC18924@kwain>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411474536-22626-4-git-send-email-antoine.tenart@free-electrons.com>
 <51745791.Wuu5QiQB2e@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51745791.Wuu5QiQB2e@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Tue, Sep 23, 2014 at 02:38:39PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 14:15:30 Antoine Tenart wrote:
> > +Optional properties:
> > +- port-id: should be '0','1' or '2'.
> > +- phy-addr: MDIO address of the PHY.
> > +- local-mac-address: see ethernet.txt file in the same directory.
> > +
> > 
> 
> I believe new bindings should not use "phy-addr" properties, but
> instead use a phy-handle property pointing to a phy device instead.

That's the MDIO address of the PHY. It's a bit difficult to use a phy
device as the driver uses the libphy. And that would break the platform
using it.

Or maybe you have something in mind?

> 
> The port-id property description could be a little more verbose.
> What do those numbers actually mean?

I'll add some description. That's the Ethernet port number. I reused a
property (port-id) already used by other drivers.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
