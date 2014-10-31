Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaJaRRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:17:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40520 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaJaRRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:17:05 -0400
Date: Fri, 31 Oct 2014 17:16:58 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] arm64: Add Juno SoC device tree.
Message-ID: <20141031171658.GK1069@e106497-lin.cambridge.arm.com>
References: <1414771460-7340-1-git-send-email-Liviu.Dudau@arm.com>
 <1414771460-7340-4-git-send-email-Liviu.Dudau@arm.com>
 <20141031162918.GG32139@lunn.ch>
MIME-Version: 1.0
In-Reply-To: <20141031162918.GG32139@lunn.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 31 Oct 2014 17:16:59.0661 (UTC) FILETIME=[7AEBD3D0:01CFF52E]
X-MC-Unique: 114103117170100601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 04:29:18PM +0000, Andrew Lunn wrote:
> On Fri, Oct 31, 2014 at 04:04:20PM +0000, Liviu Dudau wrote:
> > This adds support for USB, 100MB Ethernet port, timers, I2C,
> > and watchdog timer. Missing for now are the SMMU nodes, HDLCD
> > and PCIe.
> 
> Hi Liviu

Hi Andrew,

> 
> I know nothing about Juno, but i do help maintain the Marvell SoC
> device tree files.
> 
> It seems pretty normal to split device tree descriptions into a
> generic .dtsi SoC part and a number of .dts board files, one per
> board, and including the SoC .dtsi file.

Agree.

> 
> Is it likely another board will be designed using the same SoC?

There is at least one revision of the SoC happening, but hopefully
it should be compatible with the current DT. ARM usually creates
CoreTiles for the CPUs and uses the VExpress motherboard as the
"expansion board" sort of setup.

Juno is new in this area in that is an 'all-in-one' board. I don't
think we will ever see another board with the Juno chip because
ARM doesn't sell chips, but there might be future ARM boards that
will share features with Juno, so refactoring will be necessary.
Unfortunately, I don't have any insights into the future so I
cannot properly prepare for such case, hence the one file submission.

Best regards,
Liviu

> 
>    Andrew
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

