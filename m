Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaCZQY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:24:59 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:48037 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaCZQY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:24:57 -0400
Date: Wed, 26 Mar 2014 17:23:02 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tejun Heo <tj@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix Marvell SATA driver dependencies
Message-ID: <20140326162302.GG25349@lunn.ch>
References: <5138028.BSQbEP7RRB@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5138028.BSQbEP7RRB@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 05:19:02PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Make sata_mv host driver depend on PCI || ARCH_KIRKWOOD || ARCH_MVEBU ||
> ARCH_ORION5X config options as Marvell SATA support covers both Marvell
> PCI devices and Marvell Kirkwood, Armada 370/XP and Orion5x SoCs (for
> non-PCI devices the driver to work requires suitable device tree node to
> be defined).  Additionally allow the driver build if COMPILE_TEST config
> option is set.

Hi Bartlomiej

I _think_ there are a few powerpc platforms which can also make use of
this driver.

     Andrew
