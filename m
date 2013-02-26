Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab3BZJXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:23:55 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62227 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3BZJXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:23:50 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 26 Feb 2013 10:23:48 +0100
Message-ID: <CA+icZUWWXg31mQgDwBspAdLG2gQisxZ+M8n6isKYurPuXF8YtQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 26 [ vfs | mm/shmem ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 4:16 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Please do not add any work destined for v3.10 to your -next included
> branches until after Linus has release v3.9-rc1.
>
> Changes since 20130223:
>
> The kbuild tree lost its build failure.
>
> The infiniband tree gained a conflict against Linus' tree.
>
> The drm tree still has its build failure for which I applied a patch.
>
> ----------------------------------------------------------------------------
>

[ Changed subject-line to correct date: Feb 26 ]

The warning I reported yesterday [0] still remains as Al's vfs-next
tree was updated some hours ago.
The correct fix [1] is pending there and will be in tommorrows next-20130227.
You still need to revert the old ("buggy") commit first in Linux-Next.
Just as a note:
The function is called "shmem_file_setup()" not "shmem_setup_file()"
as the subject-line of both patches indicates.

The pending patch fixes the warnings here!

- Sedat -

[0] http://marc.info/?l=linux-kernel&m=136179858021827&w=2
[1] http://git.kernel.org/?p=linux/kernel/git/viro/vfs.git;a=patch;h=3451538a114d738a6528b1da58e19e7d8964c647
[2] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=7dbc68fcb0cdce27737dba9ee252f26d39d75fb6
