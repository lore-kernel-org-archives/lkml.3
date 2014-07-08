Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaGHMgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:36:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37732 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754335AbaGHMgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:36:42 -0400
Date: Tue, 8 Jul 2014 14:36:37 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/7] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140708123637.GA5330@kwain>
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404728173-20263-2-git-send-email-antoine.tenart@free-electrons.com>
 <53BBE419.8080107@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BBE419.8080107@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 08, 2014 at 05:59:13PM +0530, Kishon Vijay Abraham I wrote:
> Hi Antoine,
> 
> On Monday 07 July 2014 03:46 PM, Antoine Ténart wrote:
> > The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
> > 
> > The mode selection can let us think this PHY can be configured to fit
> > other purposes. But there are reasons to think the SATA mode will be
> > the only one usable: the PHY registers are only accessible indirectly
> > through two registers in the SATA range, the PHY seems to be integrated
> > and no information tells us the contrary. For these reasons, make the
> > driver a SATA PHY driver.
> 
> Thanks for doing multiple revisions of this. Looks good to be merged for me now.

Great!

Thanks,
Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
