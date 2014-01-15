Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaAOTjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:39:11 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751314AbaAOTjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:39:09 -0500
From: Richard Weinberger <richard@nod.at>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: Tree for Jan 15 (um, rcu)
Date: Wed, 15 Jan 2014 20:39:03 +0100
Message-ID: <2114717.uibXxy8kL0@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52D6B591.3070707@infradead.org>
References: <20140115185545.497c14923814b6ecaa540d9f@canb.auug.org.au> <52D6B591.3070707@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 15. Januar 2014, 08:21:37 schrieb Randy Dunlap:
> On 01/14/2014 11:55 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > This tree fails (more than usual) the powerpc allyesconfig build.
> 
> > Changes since 20140114:
> on i386 and/or x86_64 defconfigs:
> 
>   CC      arch/um/kernel/asm-offsets.s
> In file included from include/linux/sched.h:43:0,
>                  from arch/x86/um/shared/sysdep/kernel-offsets.h:2,
>                  from arch/um/kernel/asm-offsets.c:1:
> include/linux/rculist.h: In function '__list_add_rcu':
> include/linux/rculist.h:54:2: error: implicit declaration of function
> 'smp_store_release' [-Werror=implicit-function-declaration] cc1: some
> warnings being treated as errors
> make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1

Thanks for reporting Randy!

Stephen, can you please add my UML tree to -next?
It contains already the fix.
git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git next

Please note there is a trivial merge conflict in arch/um/include/asm/Kbuild.

Thanks,
//richard
