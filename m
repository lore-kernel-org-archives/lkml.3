Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaJBPpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:45:01 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63874 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaJBPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:44:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Robert Richter <rric@kernel.org>, Olof Johansson <olof@lixom.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Subject: Re: [GIT PULL] arm64, thunder: Enable Cavium Thunder SoC Family
Date: Thu, 02 Oct 2014 17:44:48 +0200
Message-ID: <10758908.VF9CYFtfmA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141002144452.GO20170@rric.localhost>
References: <1410544187-15876-1-git-send-email-rric@kernel.org> <20141002072938.GM20170@rric.localhost> <20141002144452.GO20170@rric.localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DLkQe66vdxFLIhLWgyrpqvDsWNsrJXhhzgOgWn4X2Rk
 pAa5f00CtLSXIV0dJu7tC+LHqSg1t2A4qSzL0Au0/5FDVJ98Q3
 bMn4g0MwWxXefeow3m3nTdSsYOmALNv91ZJ/rO3PRQKGDM1xBj
 JQZHJLXeYkG5l3rzUonbzFzOggKFolv+ioiMWtRnqGEKk9/DcN
 T4b3663lbWCGs8b2yq8w+PoA9Cm+tRbkxm4+D00Q+RdALGJf72
 jj4jAktG3JRq2VjeJ4FIYa0atQSaqk2Ig7rUKw2IeJbwo3BDS8
 v11kjtacbMd4AFz0nt8X+ItI7PxtwFh1vMJvNxFUlzvNi2xfaY
 MfysXlhZ0AAyGBiPLxQ4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2014 16:44:52 Robert Richter wrote:
> The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:
> 
>   Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git tags/for-arm-soc-v3.18
> 
> for you to fetch changes up to 1200e87a26b6b4fe1f473267c83515117e08ee39:
> 
>   arm64, defconfig: Enable Cavium Thunder SoC in defconfig (2014-09-23 15:10:55 +0200)
> 
> ----------------------------------------------------------------
> Enablement patches for Cavium Thunder SoC Family. The patches add
> devicetree and Kconfig support and then add Thunder to the defconfig.

I've pulled them into a new next/arm64 branch in the arm-soc tree,
but noticed that you had based them on top of -rc5. If you have no
strong reasons to pick a newer -rc, it's better to base on top of
-rc1, to save us trouble with backmerges.

I ended up rebasing to -rc1, since you gave the option to apply the
patches directly.

I originally missed the patches because they were not sent to
arm@kernel.org but only to our personal addresses. Please include
the arm@kernel.org address whenever you want patches or pull requests
to get applied (as opposed to reviewed). We are not really taking
new code for arm-soc any more, but this one was first submitted
for inclusion a while back, so I'm making an exception.

Finally, I also wanted to pull your "dts, kbuild: Implement support
for dtb vendor subdirs", but that clearly conflicts with this series,
and I decided not to pull that and take this one instead.

I'm guessing we'd see conflicts with other patches in linux-next,
so I'd rather not do the merge any more now, we can take that one
for 3.19.

	Arnd
