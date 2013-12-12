Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab3LLMjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:39:24 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64604 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3LLMjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:39:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19gsryTwMz76LvClSilrIXjsMviz4Nt31I=
Date: Thu, 12 Dec 2013 07:38:59 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Gregory CLEMENT'" <gregory.clement@free-electrons.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        "'Kuninori Morimoto'" <kuninori.morimoto.gx@renesas.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Simon Horman'" <horms@verge.net.au>, linux-sh@vger.kernel.org,
        "'Magnus Damm'" <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        "'Valentine Barshak'" <valentine.barshak@cogentembedded.com>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        linux-tegra@vger.kernel.org, "'Shawn Guo'" <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
Message-ID: <20131212123859.GH10053@titan.lakedaemon.net>
References: <20131211183237.GI4699@google.com>
 <52A96877.90902@free-electrons.com>
 <001901cef71a$41f3a520$c5daef60$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001901cef71a$41f3a520$c5daef60$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 06:12:18PM +0900, Jingoo Han wrote:
> On Thursday, December 12, 2013 4:41 PM, Gregory CLEMENT wrote:
> > On 11/12/2013 19:32, Bjorn Helgaas wrote:
> > > If this looks reasonable, I'll merge it via the PCI tree for v3.13.
> > >
> > > Bjorn
> 
> [.....]
> 
> > > +PCI DRIVER FOR MVEBU (Marvell Armada 370 and Armada XP SOC support)
> > > +M:	Jason Cooper <jason@lakedaemon.net>
> > > +L:	linux-pci@vger.kernel.org
> > > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > > +S:	Maintained
> > > +F:	drivers/pci/host/*mvebu*
> > 
> > I think that Thomas Petazzoni would be more appropriate, he worked
> > on the mvebu PCIe since 6 moths and now know very well the
> > subject. Until now all the mvebu PCIe related questions were
> > managed by Thomas.
> 
> I think so, too. :-)
> 
> Thomas Petazzoni is the author of the  mvebu PCIe. Also, he did
> The basic foundation of PCIe Host with Thierry Reding.  I think
> That he is the best person for the Maintainer of the mvebu PCIe.

100% Ack.  Thanks for the nomination, but Thomas is the person best
suited to review patches and maintain the driver.  If you want some
patch wrangling, I don't mind helping out, but I'd prefer Thomas be the
maintainer here.

thx,

Jason.
