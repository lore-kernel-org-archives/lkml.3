Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab3KHSs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:48:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab3KHSsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:48:55 -0500
Message-ID: <527D3215.5020909@infradead.org>
Date: Fri, 08 Nov 2013 10:48:53 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: Tree for Nov 8 (various vfs)
References: <20131108194753.c45ecb7db2fdd59e156d8acd@canb.auug.org.au>
In-Reply-To: <20131108194753.c45ecb7db2fdd59e156d8acd@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/13 00:47, Stephen Rothwell wrote:
> Hi all,
> 
> Please do *not* add any v3.14 material to linux-next until after
> v3.13-rc1 is released.
> 
> [A bit of a mess today :-(]
> 
> Changes since 20131107:
> 
> The vfs tree lost its build failure but gained a conflict against Linus'
> tree.
> 
> The userns tree gained conflicts against the vfs tree and a build failure
> caused by merge issues, so I dropped it for today.
> 
> The akpm-current tree gained conflicts against the vfs and tip trees.

on both i386 and x86_64:

vfs build errors:

fs/open.c:486:3: error: implicit declaration of function 'break_deleg_wait' [-Werror=implicit-function-declaration]
fs/namei.c:3726:3: error: implicit declaration of function 'break_deleg_wait' [-Werror=implicit-function-declaration]
fs/utimes.c:110:3: error: implicit declaration of function 'break_deleg_wait' [-Werror=implicit-function-declaration]


-- 
~Randy
