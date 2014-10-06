Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaJFIee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:34:34 -0400
Received: from [157.56.111.54] ([157.56.111.54]:31568 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751140AbaJFIea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:34:30 -0400
Date: Mon, 6 Oct 2014 10:32:20 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Robert Richter <rric@kernel.org>,
        Olof Johansson <olof@lixom.net>, Mark Rutland <Mark.Rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Subject: Re: [GIT PULL] arm64, thunder: Enable Cavium Thunder SoC Family
Message-ID: <20141006083220.GY31556@rric.localhost>
References: <1410544187-15876-1-git-send-email-rric@kernel.org>
 <20141002072938.GM20170@rric.localhost>
 <20141002144452.GO20170@rric.localhost>
 <10758908.VF9CYFtfmA@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <10758908.VF9CYFtfmA@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [78.53.85.79]
X-ClientProxiedBy: AMSPR04CA0039.eurprd04.prod.outlook.com (10.242.87.157) To
 DM2PR0701MB809.namprd07.prod.outlook.com (10.242.127.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0701MB809;
X-Forefront-PRVS: 03569407CC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6069001)(6009001)(199003)(377424004)(52604005)(51704005)(24454002)(52314003)(189002)(120916001)(10300001)(50986999)(106356001)(87976001)(92726001)(92566001)(19580395003)(97756001)(86362001)(99396003)(23726002)(76176999)(80022003)(83506001)(50466002)(54356999)(122386002)(46102003)(21056001)(4396001)(19580405001)(46406003)(85852003)(110136001)(66066001)(31966008)(97736003)(102836001)(101416001)(76506005)(64706001)(77096002)(20776003)(47776003)(76482002)(93886004)(105586002)(33656002)(40100001)(42186005)(95666004)(85306004)(107046002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0701MB809;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 02.10.14 17:44:48, Arnd Bergmann wrote:
> On Thursday 02 October 2014 16:44:52 Robert Richter wrote:
> > The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:
> > 
> >   Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git tags/for-arm-soc-v3.18
> > 
> > for you to fetch changes up to 1200e87a26b6b4fe1f473267c83515117e08ee39:
> > 
> >   arm64, defconfig: Enable Cavium Thunder SoC in defconfig (2014-09-23 15:10:55 +0200)
> > 
> > ----------------------------------------------------------------
> > Enablement patches for Cavium Thunder SoC Family. The patches add
> > devicetree and Kconfig support and then add Thunder to the defconfig.
> 
> I've pulled them into a new next/arm64 branch in the arm-soc tree,
> but noticed that you had based them on top of -rc5. If you have no
> strong reasons to pick a newer -rc, it's better to base on top of
> -rc1, to save us trouble with backmerges.
> 
> I ended up rebasing to -rc1, since you gave the option to apply the
> patches directly.

thanks for applying the patches.

Ok, I think a reason to update to -rc5 was a conflict in another patch
of my patch stack unrelated to this series. Wasn't aware of
backmerging conflicts you might get and will avoid unnecessary updates
in the future.

> I originally missed the patches because they were not sent to
> arm@kernel.org but only to our personal addresses. Please include
> the arm@kernel.org address whenever you want patches or pull requests
> to get applied (as opposed to reviewed). We are not really taking
> new code for arm-soc any more, but this one was first submitted
> for inclusion a while back, so I'm making an exception.

Will use arm@kernel.org in next requests.

> Finally, I also wanted to pull your "dts, kbuild: Implement support
> for dtb vendor subdirs", but that clearly conflicts with this series,
> and I decided not to pull that and take this one instead.

I was hoping one or the other patch set would have applied earlier,
then I could have rebased them. Anyway, will do this now and let you
know after the merge window closed.

> I'm guessing we'd see conflicts with other patches in linux-next,
> so I'd rather not do the merge any more now, we can take that one
> for 3.19.

Fine with me.

-Robert
