Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3LLUsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:48:39 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32989 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566Ab3LLUsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:48:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Ajhu89UKLI/PiVKVxa2ARDPPS1h4SGnM=
Date: Thu, 12 Dec 2013 15:48:16 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Richard Zhu <r65037@freescale.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH v2] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car
 PCI host maintainers
Message-ID: <20131212204816.GA2609@titan.lakedaemon.net>
References: <20131211183237.GI4699@google.com>
 <20131212204610.GK4699@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212204610.GK4699@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 01:46:10PM -0700, Bjorn Helgaas wrote:
> [+cc Thomas]
> 
> On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> > If this looks reasonable, I'll merge it via the PCI tree for v3.13.
> 
> OK, here's another try.  I'm not actually trying to nominate anybody; I
> just tried to write down the list we came up with in an earlier discussion [1].
> 
> I'd like confirmation from the following people that they approve of being
> listed here:
> 
>   Richard Zhu (IMX6)
>   Thomas Petazzoni (MVEBU)
>   Magnus Damm (R-CAR)
> 
> I think everybody else listed has already said they approve.
> 
> [1] http://lkml.kernel.org/r/CAErSpo5tN==4nSv2u3SUBe_L4VsWn4P7TN+LtrC172Qj1vhtog@mail.gmail.com
> 
> 
> MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers
> 
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Add entries for PCI host controller drivers in drivers/pci/host/.
> 
> Signed-off-by: Mohit Kumar <mohit.kumar@st.com>		(DesignWare)
> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>	(DesignWare)
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Simon Horman <horms+renesas@verge.net.au>	(R-CAR)
> Acked-by: Jason Cooper <jason@lakedaemon.net>		(MVEBU)

If Thomas is ok with it:

Double-Plus-Acked-by: Jason Cooper <jason@lakedaemon.net>

for the mvebu bits.

thx,

Jason.
