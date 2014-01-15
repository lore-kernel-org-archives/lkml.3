Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaAOQVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:21:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42082 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaAOQVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:21:41 -0500
Message-ID: <52D6B591.3070707@infradead.org>
Date: Wed, 15 Jan 2014 08:21:37 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: Tree for Jan 15 (um, rcu)
References: <20140115185545.497c14923814b6ecaa540d9f@canb.auug.org.au>
In-Reply-To: <20140115185545.497c14923814b6ecaa540d9f@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 11:55 PM, Stephen Rothwell wrote:
> Hi all,
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140114:
> 

on i386 and/or x86_64 defconfigs:

  CC      arch/um/kernel/asm-offsets.s
In file included from include/linux/sched.h:43:0,
                 from arch/x86/um/shared/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/linux/rculist.h: In function '__list_add_rcu':
include/linux/rculist.h:54:2: error: implicit declaration of function 'smp_store_release' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1


-- 
~Randy
