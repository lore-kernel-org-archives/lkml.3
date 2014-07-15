Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494AbaGOUNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:13:51 -0400
Received: from [74.50.51.50] ([74.50.51.50]:59812 "EHLO utopia.booyaka.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933422AbaGOUNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:13:46 -0400
Date: Tue, 15 Jul 2014 20:13:45 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
cc: Rajendra Nayak <rnayak@ti.com>, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-omap@vger.kernel.org,
        tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm: dra7xx: Add hwmod data for pcie1 and pcie2
 subsystems
In-Reply-To: <53C3B251.8000209@ti.com>
Message-ID: <alpine.DEB.2.02.1407152013310.21432@utopia.booyaka.com>
References: <1403719366-9656-3-git-send-email-kishon@ti.com> <1404896567-32204-1-git-send-email-kishon@ti.com> <53BD2136.9030009@ti.com> <53C3B251.8000209@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Kishon Vijay Abraham I wrote:

> On Wednesday 09 July 2014 04:32 PM, Rajendra Nayak wrote:
> > On Wednesday 09 July 2014 02:32 PM, Kishon Vijay Abraham I wrote:
> >> Added hwmod data for pcie1 and pcie2 subsystem present in DRA7xx SOC.
> >>
> >> Cc: Tony Lindgren <tony@atomide.com>
> >> Cc: Russell King <linux@arm.linux.org.uk>
> >> Cc: Paul Walmsley <paul@pwsan.com>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> Tested-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> ---
> >> Changes from v1:
> >> * changed the clock domain to "pcie_clkdm"
> >> * Added PCIe as a slave port for l3_main.
> > 
> > Looks good to me,
> > Reviewed-by: Rajendra Nayak <rnayak@ti.com>
> 
> Paul,
> 
> Can you pick this one?

Yep, queued for 3.17.

- Paul
