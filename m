Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaA0R6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:58:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:42334 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaA0R6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:58:04 -0500
Date: Mon, 27 Jan 2014 12:58:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 24
Message-ID: <20140127175825.GB21205@windriver.com>
References: <20140124154002.6020ae0892c30c82c77d7adf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140124154002.6020ae0892c30c82c77d7adf@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: Tree for Jan 24] On 24/01/2014 (Fri 15:40) Stephen Rothwell wrote:

> Hi all,
> 
> There will be no tree on Monday (26/1) as it is a public holiday.
> 
> Please do *not* add material destined for v3.15 to your linux-next
> included trees until after v3.14-rc1 is released.
> 
> This tree fails (more than usual) the powerpc allyesconfig build.

FWIW, there were a lot of new 32bit fails on the bonding driver.
These will be fixed in Tuesday's tree via this commit:

commit 0681a28264dcf948e0236adb7bf505a638c4dec1
Author: Nikolay Aleksandrov <nikolay@redhat.com>
Date:   Thu Jan 23 23:43:43 2014 +0100

    bonding: fix u64 division
    
coming in via the davem net tree.

Paul.
--

> 
> Changes since 20140123:
> 
> Dropped trees: imx-mxs (complex merge conflicts against the arm tree)
> 	scsi (complex merge conflicts with Linus' tree)
> 
> The powerpc tree still had its build failure.
> 
> The staging tree gained a build failure for which I disabled a driver.
> 
> The scsi tree gained conflict against the version of it merged into
> Linus' tree so I just dropped it for today.
> 
> The init tree lost two of its patches.
> 
> Non-merge commits (relative to Linus' tree): 6876
>  7279 files changed, 331484 insertions(+), 151447 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
> multi_v7_defconfig for arm. After the final fixups (if any), it is also
> built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
> allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES - this fails its final
> link) and i386, sparc, sparc64 and arm defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
> 
> Below is a summary of the state of the merge.
> 
> I am currently merging 208 trees (counting Linus' and 28 trees of patches
> pending for Linus' tree).
> 
> Stats about the size of the tree over time can be seen at
> http://neuling.org/linux-next-size.html .
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
> 
> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
> Gortmaker for triage and bug fixes.
> 
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 

