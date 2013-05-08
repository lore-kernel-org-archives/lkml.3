Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3EHSFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:05:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:41265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3EHSFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:05:22 -0400
Message-ID: <518A93BD.3020300@infradead.org>
Date: Wed, 08 May 2013 11:04:45 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: linux-next: Tree for May 8 (dlm)
References: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
In-Reply-To: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/13 21:01, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any v3.11 destined work to your linux-next included
> branches until after v3.10-rc1 is released.
> 
> I am receiving a (un)reasonable number of conflicts from there being
> multiple copies of some commits in various trees.   Please clean this up
> and resist the temptataion to rebase your trees on the way to your
> upstream ...
> 
> Changes since 20130506:
> 
> <crickets :-)>
> 

on x86_64:

when CONFIG_GFS2_FS_LOCKING_DLM=y and CONFIG_DLM=m:

fs/built-in.o: In function `gfs2_lock':
file.c:(.text+0xa512c): undefined reference to `dlm_posix_get'
file.c:(.text+0xa5140): undefined reference to `dlm_posix_unlock'
file.c:(.text+0xa514a): undefined reference to `dlm_posix_lock'
fs/built-in.o: In function `gdlm_cancel':
lock_dlm.c:(.text+0xb3f57): undefined reference to `dlm_unlock'
fs/built-in.o: In function `gdlm_unmount':
lock_dlm.c:(.text+0xb40ff): undefined reference to `dlm_release_lockspace'
fs/built-in.o: In function `sync_unlock.isra.4':
lock_dlm.c:(.text+0xb420d): undefined reference to `dlm_unlock'
fs/built-in.o: In function `sync_lock.isra.5':
lock_dlm.c:(.text+0xb42d9): undefined reference to `dlm_lock'
fs/built-in.o: In function `gdlm_put_lock':
lock_dlm.c:(.text+0xb45e7): undefined reference to `dlm_unlock'
fs/built-in.o: In function `gdlm_mount':
lock_dlm.c:(.text+0xb4928): undefined reference to `dlm_new_lockspace'
lock_dlm.c:(.text+0xb4c75): undefined reference to `dlm_release_lockspace'
fs/built-in.o: In function `gdlm_lock':
lock_dlm.c:(.text+0xb529f): undefined reference to `dlm_lock'



-- 
~Randy
