Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaIZOhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:37:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35105 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755882AbaIZOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:37:41 -0400
Date: Fri, 26 Sep 2014 16:37:37 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/10] ARM: Berlin: Ethernet support
Message-ID: <20140926143737.GA23559@kwain>
References: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:33:46PM +0200, Antoine Tenart wrote:
> Hi all,
> 
> This series introduce support for the Ethernet controller on Berlin SoCs,
> using the existing pxa168 Ethernet driver. In order to do this, DT
> support is added to the driver alongside some other modifications and
> fixes.
> 
> This has been tested on a Berlin BG2Q DMP board.
> 
> Changes since v4:
> 	- removed the phy-addr property and added a phy subnode
> 	- added COMPILE_TEST for the pxa168_eth driver
> 
> Changes since v3:
>         - moved the addition of pxa168_eth_get_mac_address() to the patch
>           using it first
> 
> Changes since v2:
>         - reworked how the MAC address is configured
>         - made the clock anonymous
> 
> Changes since v1:
>         - removed custom Berlin Ethernet driver
>         - used the pxa168 Ethernet driver instead
>         - made modifications to the pxa168 driver (DT support, fixes)
> 

That's really the cover letter for the v5, not v6, I made a typo in the
subject...

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
