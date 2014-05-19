Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaESLJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:09:33 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:53786 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbaESLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:09:31 -0400
Message-ID: <1400497768.2007.10.camel@x220>
Subject: Re: [PATCH v6 10/17] ARM: mvebu: add USB3 support for Armada 38x
From: Paul Bolle <pebolle@tiscali.nl>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Date: Mon, 19 May 2014 13:09:28 +0200
In-Reply-To: <20140516190729.GN27822@titan.lakedaemon.net>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
	 <1400149062-32661-11-git-send-email-gregory.clement@free-electrons.com>
	 <20140516190729.GN27822@titan.lakedaemon.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 May 2014 11:09:29.0026 (UTC) FILETIME=[CD8F3220:01CF7352]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 15:07 -0400, Jason Cooper wrote:
> On Thu, May 15, 2014 at 12:17:35PM +0200, Gregory CLEMENT wrote:
> > This patch adds the selection of the config symbol needed to build the
> > USB3 support for Armada 38x into mvebu_v7_defconfig.
> > 
> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > ---
> >  arch/arm/mach-mvebu/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Patches 10 and 11 applied to mvebu/soc

These two just hit linux-next (in next-20140519). They're pointless, as
config USB_ARCH_HAS_XHCI was dropped in commit b797b76fb464 ("usb: host:
remove USB_ARCH_HAS_?HCI").


Paul Bolle

