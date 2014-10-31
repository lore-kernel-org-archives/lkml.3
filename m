Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbaJaQaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:30:35 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:46938 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbaJaQae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:30:34 -0400
Date: Fri, 31 Oct 2014 17:29:18 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 3/3] arm64: Add Juno SoC device tree.
Message-ID: <20141031162918.GG32139@lunn.ch>
References: <1414771460-7340-1-git-send-email-Liviu.Dudau@arm.com>
 <1414771460-7340-4-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414771460-7340-4-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 04:04:20PM +0000, Liviu Dudau wrote:
> This adds support for USB, 100MB Ethernet port, timers, I2C,
> and watchdog timer. Missing for now are the SMMU nodes, HDLCD
> and PCIe.

Hi Liviu

I know nothing about Juno, but i do help maintain the Marvell SoC
device tree files.

It seems pretty normal to split device tree descriptions into a
generic .dtsi SoC part and a number of .dts board files, one per
board, and including the SoC .dtsi file.

Is it likely another board will be designed using the same SoC?

   Andrew
