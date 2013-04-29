Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab3D2WzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:55:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46991 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab3D2WzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:55:18 -0400
Date: Mon, 29 Apr 2013 15:55:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Li Zefan <lizefan@huawei.com>
Subject: Re: linux-next: build failure after merge of the cgroup tree
Message-ID: <20130429225513.GG2395@htj.dyndns.org>
References: <20130429140433.92d05cd48b66ac323616d572@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429140433.92d05cd48b66ac323616d572@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 29, 2013 at 02:04:33PM +1000, Stephen Rothwell wrote:
> I have added the following merge fix patch for today (but it should be
> applied to the powerpc tree ASAP).
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 29 Apr 2013 14:01:44 +1000
> Subject: [PATCH] powerpc: numa.c: using kzalloc/kfree requires including
>  slab.h
> 
> fixes these build errors:
> 
> arch/powerpc/mm/numa.c: In function 'arch_update_cpu_topology':
> arch/powerpc/mm/numa.c:1465:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
> arch/powerpc/mm/numa.c:1465:10: error: assignment makes pointer from integer without a cast [-Werror]
> arch/powerpc/mm/numa.c:1497:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Tejun Heo <tj@kernel.org>

Benjamin, can you please pick this up?

Thanks a lot and sorry about the trouble.

-- 
tejun
