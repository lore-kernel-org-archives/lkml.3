Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3FKHby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:31:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15584 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3FKHbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:31:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 11 Jun 2013 00:30:51 -0700
Date: Tue, 11 Jun 2013 10:30:48 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Jay Agarwal <jagarwal@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
Subject: Re: [PATCH V3 3/4] ARM: dts: tegra: Correct PCIe entry
Message-ID: <20130611073048.GR3847@tbergstrom-lnx.Nvidia.com>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
 <1370372252-4332-3-git-send-email-jagarwal@nvidia.com>
 <20130610195511.GC25859@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130610195511.GC25859@mithrandir>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 09:55:12PM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Wed, Jun 05, 2013 at 12:27:31AM +0530, Jay Agarwal wrote:
> [...]
> > @@ -29,7 +29,7 @@
> >  		ranges = <0x82000000 0 0x00000000 0x00000000 0 0x00001000   /* port 0 configuration space */
> >  			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 configuration space */
> >  			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 configuration space */
> > -			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream I/O */
> > +			  0x81000000 0 0          0x02000000 0 0x00100000   /* downstream I/O */
> >  			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefetchable memory */
> >  			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchable memory */
> 
> That increases the I/O region size from 64 KiB to 1 MiB. Why is that
> necessary? I/O operations can only address 64 KiB, so I don't think
> adding more makes any sense.

At least PCI allows 32bit I/O addresses. No idea if anyone uses them though.

Cheers,

Peter.
