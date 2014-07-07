Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaGGFtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:49:36 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:7108
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750736AbaGGFtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:49:33 -0400
Date: Mon, 7 Jul 2014 13:49:25 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Liu Ying <Ying.Liu@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] bus: imx-weim: populate devices on a simple bus
Message-ID: <20140707054923.GL30239@dragon>
References: <1404464441-31755-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1404464441-31755-1-git-send-email-Ying.Liu@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(199002)(189002)(51704005)(80022001)(83322001)(97736001)(54356999)(95666004)(4396001)(46102001)(46406003)(81342001)(76482001)(76176999)(81542001)(104016002)(105606002)(85306003)(19580405001)(44976005)(21056001)(99396002)(50986999)(74662001)(57986006)(92726001)(106466001)(87936001)(47776003)(86362001)(83072002)(64706001)(77982001)(97756001)(85852003)(23726002)(102836001)(19580395003)(74502001)(6806004)(50466002)(69596002)(20776003)(68736004)(26826002)(33656002)(83506001)(31966008)(81156004)(84676001)(79102001)(107046002)(33716001)(92566001)(110136001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB525;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 05:00:41PM +0800, Liu Ying wrote:
> There could be some memory map devices located in
> a certain chip select region of the i.MX WEIM.
> The devices could be attached to a simple bus(for
> example, a AXI bus) whose root node is one child
> device tree node of the i.MX WEIM device tree node.
> There should be a bridge(very likely, software
> transparent) bewteen the i.MX WEIM and the simple bus.
> This patch makes the i.MX WEIM driver possible to
> populate devices on a simple bus.  In this way, people
> may try various IPs(in a FPGA, maybe) outside of i.MX
> chips with the i.MX WEIM embedded.
> 
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>

Applied, thanks.
