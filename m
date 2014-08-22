Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbaHVQbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:31:34 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:58530
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932487AbaHVQbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:31:32 -0400
Date: Fri, 22 Aug 2014 09:31:20 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
 <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
 <53F5D8D9.7040604@suse.de>
 <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
 <20140822162048.GB8477@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140822162048.GB8477@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d31d72f2-acac-4aa3-b992-fc244ac6db4e@BY2FFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(51704005)(189002)(24454002)(377424004)(50986999)(47776003)(23676002)(64706001)(92566001)(92726001)(50466002)(70736001)(81342001)(79102001)(77982001)(31966008)(46102001)(21056001)(76482001)(4396001)(20776003)(54356999)(1496007)(76176999)(31696002)(86362001)(90102001)(99396002)(102836001)(81542001)(85182001)(93886004)(107046002)(110136001)(74502001)(80022001)(53416004)(85202003)(44976005)(74316001)(106466001)(77096002)(104016003)(83322001)(87936001)(85852003)(83072002)(83506001)(95666004)(74662001)(6806004)(85306004)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB025;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0311124FA9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 10:20AM -0600, Jason Gunthorpe wrote:
> On Thu, Aug 21, 2014 at 08:49:19AM -0700, Sören Brinkmann wrote:
> 
> > So my thinkings:
> >  - the compatible string with the -c22 is used and documented in the phy
> >    bindings, it should be there.
> 
> Yes
> 
> >  - the ID based strings seem to be not needed since, IIUC, the core
> >    reads the ID from the PHY and uses it, so I just left it out not
> >    trying to figure out how to obtain the correct ID
> 
> It is certainly optional, I added the property to solve some obscure
> problems with probing, but I've noticed people using it more broadly.
> I suspect it also speeds up booting a tiny bit.
> 
> >  - the marvell compatible strings are used in our vendor tree. They
> >    aren't used anywhere but in our vendor tree. I though keeping them is
> >    nice since it identifies the PHY fully. And in case that level of
> >    detail is needed at some point it is already there.
> 
> DT is complex enough already, don't include useless compatible strings
> in mainline - people will see and tend to blindly copy. Ideally your
> vendor tree would use the standard property :|

There are different opinions on this. I also heard to just add such
strings, so in case this level of differentiation becomes necessary at
some later point, it is already existing.

	Sören

