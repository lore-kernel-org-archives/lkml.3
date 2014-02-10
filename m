Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaBJR7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:59:19 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60075 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752312AbaBJR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:12 -0500
Date: Mon, 10 Feb 2014 18:59:08 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 6/6] dt: Update binding information for mvebu gating
 clocks with Armada 380/385
Message-ID: <20140210185908.3374eaf6@skate>
In-Reply-To: <20140210175350.GD9995@lunn.ch>
References: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
	<1392053569-28037-7-git-send-email-gregory.clement@free-electrons.com>
	<20140210175350.GD9995@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Lunn,

On Mon, 10 Feb 2014 18:53:50 +0100, Andrew Lunn wrote:
> > +The following is a list of provided IDs for Armada 380/385:
> > +ID	Clock		Peripheral
> > +-----------------------------------
> > +0	audio		Audio
> > +2	ge2		Gigabit Ethernet 2
> > +3	ge1		Gigabit Ethernet 1
> > +4	ge0		Gigabit Ethernet 0
> > +5	pex1		PCIe 1
> > +6	pex2		PCIe 2
> > +7	pex3		PCIe 3
> > +8	pex4		PCIe 0
> 
> Is that last one a typo? It at least looks a bit odd.

Right, this should be:

	8	pex0		PCIe 0

(just checked again in the datasheet)

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
