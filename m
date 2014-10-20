Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaJTPkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:40:40 -0400
Received: from mail-bn1on0058.outbound.protection.outlook.com ([157.56.110.58]:22064
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751222AbaJTPkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:40:36 -0400
Date: Mon, 20 Oct 2014 17:24:25 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Abhilash Kesavan <kesavan.abhilash@gmail.com>
CC: Robert Richter <rric@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Bresticker <abrestic@google.com>, Michal Marek <mmarek@suse.cz>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] dts, kbuild: Implement support for dtb vendor subdirs
Message-ID: <20141020152425.GY31556@rric.localhost>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
 <CAL1qeaGCeRyeKLo70E264bZcamOfBKoN9Y8_NDCjV5j4DoOw1Q@mail.gmail.com>
 <20140919123056.GC20170@rric.localhost>
 <20140919140856.GG2295@e104818-lin.cambridge.arm.com>
 <20140923112619.GG20170@rric.localhost>
 <20141002150804.GP20170@rric.localhost>
 <CAM4voakQnY1JMnjrXfTSNTyzA6_f6jtUgJZXXz2N0YRjq3kXRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM4voakQnY1JMnjrXfTSNTyzA6_f6jtUgJZXXz2N0YRjq3kXRg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [78.53.85.16]
X-ClientProxiedBy: DB4PR07CA019.eurprd07.prod.outlook.com (10.242.229.29) To
 SN2PR0701MB815.namprd07.prod.outlook.com (25.160.16.149)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:SN2PR0701MB815;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6069001)(51704005)(189002)(199003)(24454002)(80022003)(93886004)(85306004)(42186005)(76176999)(46102003)(50466002)(77096002)(76506005)(110136001)(40100003)(15202345003)(21056001)(31966008)(97756001)(83506001)(4396001)(86362001)(46406003)(66066001)(64706001)(20776003)(47776003)(23726002)(54356999)(97736003)(122386002)(87976001)(15975445006)(92726001)(92566001)(101416001)(102836001)(19580395003)(33656002)(85852003)(95666004)(120916001)(106356001)(50986999)(76482002)(105586002)(107046002)(99396003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR0701MB815;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.10.14 19:26:32, Abhilash Kesavan wrote:

> >> > > > > Robert Richter (6):
> >> > > > >   dts, arm64: Add dtbs_install make target
> >> > > > >   dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
> >> > > > >   dts, arm/arm64: Remove dtbs build rules in sub-makes
> >> > > > >   dts, kbuild: Implement support for dtb vendor subdirs
> >> > > > >   dts, arm64: Move dts files to vendor subdirs
> >> > > > >   dts, arm: Remove $(MACHINE) variable from dtbs make recipes

> > you may want to pull from here alternatively.
> 
> I have been using your patchset as the base for my new arm64 SoC
> support (http://www.spinics.net/lists/linux-samsung-soc/msg37047.html).
> Are you planning to rebase and send this again as some of the patches
> did not apply cleanly for me on linux-next.

Yes, I will rebase it and resend the pull request this week.

-Robert
