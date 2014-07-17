Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaGQAp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:45:29 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:37695 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaGQAp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:45:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140716184550.18b6da3f@canb.auug.org.au>
References: <20140716184550.18b6da3f@canb.auug.org.au>
Date: Wed, 16 Jul 2014 20:45:25 -0400
Message-ID: <CAPDOMViywcY=cYFT9EM3N3wESXQUX7uWa3jLLLKpv=QGF-Dtmw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 16
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 4:45 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20140715:
>
> The v4l-dvb tree lost its build failure.
>
> The wireless-next tree gained a build failure so I used the version
> from next-20140715.
>
> The infiniband tree gained a conflict against the net-next tree.
>
> The staging tree gained conflict against the net-next and v4l-dvb trees.
>
> The akpm tree gained a build failure due to an interaction with the
> cgroup tree for which I applied a fix patch.
>
> Non-merge commits (relative to Linus' tree): 5966
>  5609 files changed, 220568 insertions(+), 280729 deletions(-)
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
Hey Stephen,
I am trying to get the maintainers to clean up still failing builds.
When you get time I wondering
if you can send me a list  of still failing builds and warnings of
interest in the kernel that is'
up to date for me to help clean up these outstanding issues with the
maintainers support as needed.
Cheers Nick
