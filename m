Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaG3Job (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:44:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37475 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbaG3JoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:44:08 -0400
Date: Wed, 30 Jul 2014 10:43:33 +0100
From: Will Deacon <will.deacon@arm.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: smp_scu: Enable standby mode
Message-ID: <20140730094332.GC12239@arm.com>
References: <1406654463-15475-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406654463-15475-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:21:03PM +0100, Soren Brinkmann wrote:
> Enable the SCU standby mode.
> From documentation:
>   When set, SCU CLK is turned off when all processors are in WFI mode,
>   there is no pending request on the ACP (if implemented), and there is
>   no remaining activity in the SCU.
> 
>   When SCU CLK is off, ARREADYS, AWREADYS and WREADYS on the ACP are forced
>   LOW. The clock is turned on when any processor leaves WFI mode, or if
>   there is a new request on the ACP.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> Hi,
> 
> I am working on some PM related patches for Zynq. One of them is
> enabling the SCU standby mode. I was wondering whether this is probably
> something that I should not do in platform specific code, but rather in
> the common code for everybody?

Take a look at Shawn's patches for this:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275326.html

Will
