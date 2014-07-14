Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbaGNRus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:50:48 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:47184 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaGNRum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140714171755.22901059@canb.auug.org.au>
References: <20140714171755.22901059@canb.auug.org.au>
Date: Mon, 14 Jul 2014 13:50:40 -0400
Message-ID: <CAPDOMViMv48o9_3tRp+AJLGy7XCM8ggPR6x9KXSfah+Xyvrjxg@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 14
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 3:17 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20140711:
>
> My fixes tree is empty again.
>
> The tty.current tree lost its build failure.
>
> The mvebu tree gained a conflict against Linus' tree.
>
> The akpm tree lost a few patches that turned up elsewhere.
>
> Non-merge commits (relative to Linus' tree): 5571
>  5123 files changed, 207687 insertions(+), 256904 deletions(-)
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
> I am currently merging 222 trees (counting Linus' and 30 trees of patches
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
>
I am running your failing tests and most of them seem to succeed for me.
I also sent you a log of these succeeding builds.
Cheers Nick
