Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3ITDO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 23:14:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13188 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab3ITDOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 23:14:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18eeUjshfyOPNeA2h4CDMVgSgUN1W2+MLY=
Date: Thu, 19 Sep 2013 23:14:52 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Quentin Armitage <quentin@armitage.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix address of second XOR engine in Kirkwood SoC DT
Message-ID: <20130920031452.GA11119@titan.lakedaemon.net>
References: <1379588429.2484.84.camel@samson1.armitage.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379588429.2484.84.camel@samson1.armitage.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:00:29PM +0100, Quentin Armitage wrote:
> There appears to be an error in the second address of the second XOR
> engine in the Kirkwood SoC device tree, which is specified as 0xd0b00
> but should be 0x60b00.
> 
> For confirmation of address see
> http://www.marvell.com/embedded-processors/kirkwood/assets/FS_88F6180_9x_6281_OpenSource.pdf table 581 page 658.
> Also see definition of XOR1_HIGH_PHYS_BASE in
> arch/arm/mach-kirkwood/include/mach/kirkwood.h
> #define XOR1_HIGH_PHYS_BASE    (KIRKWOOD_REGS_PHYS_BASE + 0x60B00)
> 
> Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
> 
> ---
>  arch/arm/boot/dts/kirkwood.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to mvebu/fixes with Sebastian's Reviewed-by.

thx,

Jason.
