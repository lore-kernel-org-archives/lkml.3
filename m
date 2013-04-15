Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3DOPrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:47:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13361 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3DOPrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:47:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18S+CU8wfueomybnXbnkgLMkA7DuoAZFac=
Date: Mon, 15 Apr 2013 11:47:00 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Lior Amsalem <alior@marvell.com>,
        Ike Pan <ike.pan@canonical.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jon Masters <jcm@redhat.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 0/5]  LPAE remaining device tree file
Message-ID: <20130415154700.GF28693@titan.lakedaemon.net>
References: <1365776950-30094-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365776950-30094-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:29:05PM +0200, Gregory CLEMENT wrote:
> Hi Jason,
> 
> I have just rebased the commits that you haven't applied yet. They are
> rebased on mvebu/dt. I check that all the dtb can be built.
> 
> Thanks,
> 
> Gregory CLEMENT (3):
>   ARM: dts: mvebu: Convert all the mvebu files to use the range
>     property
>   ARM: dts: mvebu: introduce internal-regs node
>   ARM: dts: mvebu: Convert mvebu device tree files to 64 bits
> 
> Thomas Petazzoni (2):
>   ARM: dts: mvebu: fix cpus section indentation
>   ARM: dts: mvebu: move all peripherals inside soc
> 
>  arch/arm/boot/dts/armada-370-db.dts              |  134 +++---
>  arch/arm/boot/dts/armada-370-mirabox.dts         |  176 ++++----
>  arch/arm/boot/dts/armada-370-rd.dts              |   96 ++---
>  arch/arm/boot/dts/armada-370-xp.dtsi             |  336 +++++++--------
>  arch/arm/boot/dts/armada-370.dtsi                |  330 +++++++--------
>  arch/arm/boot/dts/armada-xp-db.dts               |  202 ++++-----
>  arch/arm/boot/dts/armada-xp-gp.dts               |  222 +++++-----
>  arch/arm/boot/dts/armada-xp-mv78230.dtsi         |  284 ++++++-------
>  arch/arm/boot/dts/armada-xp-mv78260.dtsi         |  342 +++++++--------
>  arch/arm/boot/dts/armada-xp-mv78460.dtsi         |  484 +++++++++++-----------
>  arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  262 ++++++------
>  arch/arm/boot/dts/armada-xp.dtsi                 |  202 ++++-----
>  12 files changed, 1549 insertions(+), 1521 deletions(-)

whole series applied to mvebu/dt

thx,

Jason.
