Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaITLDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 07:03:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751815AbaITLDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 07:03:20 -0400
Date: Sat, 20 Sep 2014 13:03:15 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, "Dmitriy B." <rzk333@gmail.com>,
        Yassin Jaffer <yassinjaffer@gmail.com>, Jonas Meyer <quitte@gmail.com>
Subject: Re: [PATCH v4 0/2] mtd: nand: add sunxi NAND flash controller
 support
Message-ID: <20140920130315.197ab359@bbrezillon>
In-Reply-To: <20140920043438.GD8127@brian-ubuntu>
References: <1408382788-32153-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140920043438.GD8127@brian-ubuntu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Fri, 19 Sep 2014 21:34:38 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> Hi Boris,
> 
> On Mon, Aug 18, 2014 at 07:26:26PM +0200, Boris BREZILLON wrote:
> > This patch series adds support for the sunxi NAND Flash Controller (NFC)
> > block.
> > 
> > These two patches only add support for the basic NAND stuff:
> >  - NAND controller operations
> >  - SW and HW ECC handling (with both syndrome and normal ECC scheme)
> > 
> > If you want support for advanced features you can find it on my github
> > repo [1]:
> >  - HW randomization support
> >  - per partition ECC/Randomizer to handle bootloader partitions
> > 
> > DMA transfers are not supported yet, but I have reworked the OOB layout
> > when using the HW ECC scheme to match the one used when accessing the NAND
> > with DMA transfers (the available OOB bytes are placed at the end of the
> > OOB area).
> > 
> > This patch series depends on this other one [2] which adds support for ONFI
> > timing mode retrieval on non-ONFI NANDs.
> 
> Were you planning to send v2 of your series [2]? I see you made a
> mistake you were planning on fixing:
> 
>   https://lkml.org/lkml/2014/7/30/423

Yep, I was just waiting for your feedback before fixing it ;-).

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
