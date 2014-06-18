Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966064AbaFRLUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:20:47 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:51716 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbaFRLUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:20:45 -0400
MIME-Version: 1.0
Date: Wed, 18 Jun 2014 16:50:43 +0530
X-Google-Sender-Auth: 86Q9Z3lhridR9XBvc3VhOloyBmE
Message-ID: <CAK5sBcEpXboRVD-KzzjBJMi+LF-jhdt_HUYEz7wkJtFAv+BLcg@mail.gmail.com>
Subject: Build error - vmlinux.lds [Re: linux-next: Tree for Jun 18]
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: rmk+kernel@arm.linux.org.uk, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I observe the following build error while building uImage for ARM.

  Kernel: arch/arm/boot/Image is ready
make[2]: *** No rule to make target
`arch/arm/boot/compressed/vmlinux.lds', needed by
`arch/arm/boot/compressed/vmlinux'.  Stop.
make[1]: *** [arch/arm/boot/compressed/vmlinux] Error 2
make: *** [uImage] Error 2

Regards,
Sachin.


On Wed, Jun 18, 2014 at 9:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> The powerpc allyesconfig is again broken more than usual.
>
> Changes since 20140617:
>
> Non-merge commits (relative to Linus' tree): 868
>  1021 files changed, 24269 insertions(+), 14775 deletions(-)
>
> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" and checkout or reset to the new
> master.
>
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
> multi_v7_defconfig for arm. After the final fixups (if any), it is also
> built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
> allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
> defconfig.
>
> Below is a summary of the state of the merge.
>
> I am currently merging 219 trees (counting Linus' and 29 trees of patches
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
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
