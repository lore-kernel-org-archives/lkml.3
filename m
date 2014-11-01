Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaKAWgi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:36:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57888 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750785AbaKAWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:36:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+K7PKmipuDBanIb/PfiUjAjZlvpYJdb9c=
X-DKIM: OpenDKIM Filter v2.0.1 titan ABA5E60EEBC
Date: Sat, 1 Nov 2014 18:36:25 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
Message-ID: <20141101223625.GB3698@titan.lakedaemon.net>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Fri, Sep 19, 2014 at 10:14:36PM +0200, Sebastian Hesselbarth wrote:
> Guys,
> 
> this is a patch set preparing barebox support for ix4-300d. As usual,
> I stumbled upon a few nice-to-haves before actually touching ix4-300d
> dts. As it is a mach-mvebu thing, I just added the related mailing
> lists instead of each of the DT maintainers.
> 
> First 5 patches consolidate SoC-specific pinctrl nodes to one common
> node in armada-xp.dtsi, compatible overwrites for each SoC, and node
> alias usage for each board. Also, ge{0,1} pinctrl settings are moved
> to the common node from one board specific node.
> 
> Last 3 patches then use that ge{0,1} pinctrl settings on ix4-300d which
> is vital for bootloader init. During exploration of ix4-300d, I also
> found a i2c eeprom that has not been added to the dts, yet. Finally,
> there is only one 74hc595 on ix4 mainboard while dts property is set
> for two.
> 
> I cannot recall in detail what is on that eeprom, but IIRC it is nothing
> important. Some reg,addr pairs for some init stuff that should have
> already been done by stock u-boot. Anyway, adding the node will do no
> harm.
> 
> Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
> a hurry. I only compile tested this, so a formal Tested-by from Benoit
> for the ix4 and any other Armada XP board would be great.

I lost track of this thread, are you resending?  Did Benoit get a
successful test run?

thx,

Jason.
