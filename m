Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaLYNcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 08:32:39 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:50335 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaLYNcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 08:32:36 -0500
Date: Thu, 25 Dec 2014 14:31:09 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Evgeni Dobrev <evgeni@studio-punkt.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/1] add support for Seagate BlackArmor NAS220
Message-ID: <20141225133109.GI19265@lunn.ch>
References: <20141215203855.GA28940@anne>
 <20141222125750.GA29163@anne>
 <549C0C3C.8060601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549C0C3C.8060601@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 02:08:12PM +0100, Sebastian Hesselbarth wrote:
> >+			status = "okay";
> >+		};
> >+
> >+		sata@80000 {
> >+			status = "okay";
> >+			nr-ports = <2>;
> 
> I need some update from the other mvebu guys here: Do we have SATA
> PHY nodes in v3.19 for Kirkwood already? If so, please update to the
> new binding.

Hi Sebastian

I'm not sure what you mean here. The binding Documentation says:

Required Properties:
- compatibility : "marvell,orion-sata" or "marvell,armada-370-sata"
- reg           : Address range of controller
- interrupts    : Interrupt controller is using
- nr-ports      : Number of SATA ports in use.

Optional Properties:
- phys          : List of phandles to sata phys
- phy-names     : Should be "0", "1", etc, one number per phandle

The optional phys/phy-names have just been added to
kirkwood-6192.dtsi.

	Andrew
