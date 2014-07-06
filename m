Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256AbaGFAXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 20:23:54 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:43410 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbaGFAXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 20:23:52 -0400
Date: Sun, 6 Jul 2014 00:23:51 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
cc: devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-omap@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        rnayak@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: dra7xx: Add hwmod data for pcie1 phy and pcie2
 phy
In-Reply-To: <1403719366-9656-2-git-send-email-kishon@ti.com>
Message-ID: <alpine.DEB.2.02.1407060023330.23762@utopia.booyaka.com>
References: <1403719366-9656-1-git-send-email-kishon@ti.com> <1403719366-9656-2-git-send-email-kishon@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Kishon Vijay Abraham I wrote:

> Added hwmod data for pcie1 and pcie2 phy present in DRA7xx SOC.
> Also added the missing CLKCTRL OFFSET macro and CONTEXT OFFSET macro
> for pcie1 phy and pcie2 phy.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Tested-by: Kishon Vijay Abraham I <kishon@ti.com>

Thanks, queued for v3.17 with Rajendra's ack.


- Paul
