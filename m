Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaKDPvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:51:31 -0500
Received: from [157.56.110.82] ([157.56.110.82]:17824 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999AbaKDPvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:51:23 -0500
Date: Tue, 4 Nov 2014 16:49:17 +0100
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Olof Johansson <olof@lixom.net>
CC: Robert Richter <rric@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Bresticker <abrestic@google.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>
Subject: Re: [GIT PULL] dts, kbuild: Implement support for dtb vendor subdirs
Message-ID: <20141104154917.GP31556@rric.localhost>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
 <20141021181504.GV20170@rric.localhost>
 <20141104044717.GA13562@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141104044717.GA13562@quad.lixom.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [78.53.84.41]
X-ClientProxiedBy: DB4PR07CA024.eurprd07.prod.outlook.com (10.242.229.34) To
 BLUPR0701MB803.namprd07.prod.outlook.com (10.141.253.24)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR0701MB803;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6069001)(52604005)(199003)(52044002)(24454002)(189002)(51704005)(21056001)(120916001)(76176999)(50986999)(46406003)(64706001)(54356999)(122386002)(23726002)(33656002)(46102003)(106356001)(77156002)(77096003)(95666004)(86362001)(99396003)(20776003)(66066001)(105586002)(107046002)(47776003)(42186005)(83506001)(97756001)(110136001)(76506005)(31966008)(92566001)(4396001)(92726001)(87976001)(40100003)(50466002)(102836001)(97736003)(19580395003)(101416001)(62966003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR0701MB803;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.11.14 20:47:17, Olof Johansson wrote:
> > > Robert Richter (6):
> > >   dts, arm64: Add dtbs_install make target
> > >   dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
> > >   dts, arm/arm64: Remove dtbs build rules in sub-makes
> > >   dts, kbuild: Implement support for dtb vendor subdirs
> > >   dts, arm64: Move dts files to vendor subdirs
> > >   dts, arm: Remove $(MACHINE) variable from dtbs make recipes
> > 
> > please pull this series for inclusion into v3.19 from:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git dts-subdirs-for-arm-soc-v3.19
> > 
> > I have updated and rebased the patches to v3.18-rc1. No changes except
> > conflict resolution of patch 5/6.
> 
> Pulled, and I added the description from 0/6 as the merge text -- feel free to
> add it to the tag if you do something like this in the future.

Thanks for pulling and the hint on the tag description (I was
wondering what to put in there).

-Robert
