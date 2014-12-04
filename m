Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbaLDXeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:34:19 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56938 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbaLDXeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:34:15 -0500
Date: Thu, 4 Dec 2014 15:34:11 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 4
Message-ID: <20141204233411.GA1223@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20141204195928.4a5b93f4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204195928.4a5b93f4@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all,

On Thu, Dec 04, 2014 at 07:59:28PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141203:
> 
> The usb tree still had its build failure so I used the version from
> next-20141128.
> 
> Non-merge commits (relative to Linus' tree): 10075
>  9350 files changed, 375991 insertions(+), 275936 deletions(-)
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
> I am currently merging 229 trees (counting Linus' and 32 trees of patches
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
[...]

linux-next 20141204 is broken on all my machines, 20141203 worked fine.

They fail very early in the boot process and are unable to mount root.
There are lots of "ext4_check_descriptors: Checksum for group ...
failed" messages.

Any suggestions for where to start looking?

-- 
- Jeremiah Mahler
