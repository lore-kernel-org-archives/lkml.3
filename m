Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaIIQBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:01:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59188 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753914AbaIIQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:01:40 -0400
Date: Tue, 9 Sep 2014 18:01:36 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] Documentation: bindings: net: add the Marvell
 PXA168 Ethernet controller
Message-ID: <20140909160136.GA26051@kwain>
References: <1410273848-24663-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410273848-24663-4-git-send-email-antoine.tenart@free-electrons.com>
 <3827594.chb831jyvc@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3827594.chb831jyvc@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Tue, Sep 09, 2014 at 05:58:12PM +0200, Arnd Bergmann wrote:
> On Tuesday 09 September 2014 16:44:03 Antoine Tenart wrote:
> > +- clocks: pointer to the clock for the device.
> > +- clock-names: should be "MFUCLK".
> 
> Clock names are normally not capitalized. Are you able to change
> that name when providing a binding or make it an anoymous clock?
> What does MFU stand for anyway?

Sure. I could have make it an anonymous clock but the name "MFUCLK" was
already used by the pxa168 Ethernet driver so I didn't wanted to change
that.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
