Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaG3P32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:29:28 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:14753
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753622AbaG3P3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:29:25 -0400
Date: Wed, 30 Jul 2014 08:29:13 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Will Deacon <will.deacon@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: smp_scu: Enable standby mode
References: <1406654463-15475-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140730094332.GC12239@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140730094332.GC12239@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <0551c7f6-ea12-426d-8941-2fe1a2e4676d@BN1BFFO11FD013.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(377424004)(51704005)(24454002)(164054003)(53416004)(1496007)(4396001)(76176999)(44976005)(15975445006)(85182001)(74316001)(31696002)(15202345003)(6806004)(86362001)(92566001)(85852003)(19580395003)(83072002)(92726001)(50986999)(106466001)(83322001)(54356999)(99396002)(19580405001)(87936001)(83506001)(33646002)(81542001)(104016003)(23676002)(77096002)(79102001)(64706001)(77982001)(85202003)(20776003)(47776003)(107046002)(80022001)(110136001)(74502001)(70736001)(95666004)(46102001)(74662001)(31966008)(85306003)(21056001)(76482001)(50466002)(81342001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB032;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0288CD37D9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 10:43AM +0100, Will Deacon wrote:
> On Tue, Jul 29, 2014 at 06:21:03PM +0100, Soren Brinkmann wrote:
> > Enable the SCU standby mode.
> > From documentation:
> >   When set, SCU CLK is turned off when all processors are in WFI mode,
> >   there is no pending request on the ACP (if implemented), and there is
> >   no remaining activity in the SCU.
> > 
> >   When SCU CLK is off, ARREADYS, AWREADYS and WREADYS on the ACP are forced
> >   LOW. The clock is turned on when any processor leaves WFI mode, or if
> >   there is a new request on the ACP.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > Hi,
> > 
> > I am working on some PM related patches for Zynq. One of them is
> > enabling the SCU standby mode. I was wondering whether this is probably
> > something that I should not do in platform specific code, but rather in
> > the common code for everybody?
> 
> Take a look at Shawn's patches for this:
> 
>   http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275326.html

Great, so that is already coming. Is that patch already applied
somewhere?

	Thanks,
	Sören

