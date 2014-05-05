Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaEEArL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:47:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28323 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753891AbaEEArJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:47:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+er64uopTQVpMqKivfCBbI62DgZbGnoRM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0C6C456B663
Date: Sun, 4 May 2014 20:46:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ARM: dts: kirkwood: fix mislocated
 pcie-controller nodes
Message-ID: <20140505004627.GC28159@titan.lakedaemon.net>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1398862602-29595-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398862602-29595-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 02:56:28PM +0200, Sebastian Hesselbarth wrote:
> Commit 54397d85349f
>  ("ARM: kirkwood: Relocate PCIe device tree nodes")
> 
> moved the pcie-controller nodes for the Kirkwood SoCs to the mbus
> bus node. For some reason, two boards were not properly converted
> and have their pci-controller nodes still in the ocp bus node.
> 
> As the corresponding SoC pcie-controller does not exist anymore,
> it is likely that pcie is broken on those boards since above commit.
> Fix it by moving the pcie related nodes to the correct location.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts | 18 ++++++++++--------
>  arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi  | 18 ++++++++++--------
>  2 files changed, 20 insertions(+), 16 deletions(-)

Applied to mvebu/dt-fixes with Andrew's Ack and flagged for backporting
to -stable v3.12+

thx,

Jason.
