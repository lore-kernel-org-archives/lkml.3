Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965091AbaFCWqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:46:19 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:34093 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaFCWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140604083411.4296bcd5@canb.auug.org.au>
References: <20140604083411.4296bcd5@canb.auug.org.au>
Date: Tue, 3 Jun 2014 18:46:17 -0400
X-Google-Sender-Auth: qZ8d7VHAAm5lxAwsWd7oGDuDv7k
Message-ID: <CAABAsM4hpz_vCK=AbLUzBnVCr3-_5KhJUqif3YP3Yjp+-ojx8w@mail.gmail.com>
Subject: Re: linux-next: bad commits in the nfs tree
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anna Schumaker <Anna.Schumaker@netapp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 6:34 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Trond,
>
> I noticed in the nfs tree this morning 2 commits that have been
> cherry-picked from Linus' tree:
>
> cc6d854967ce    Linux 3.15-rc8
> 2b267bb3a8e5    powerpc: Wire renameat2() syscall
>
> These are part of a branch that you merged from Anna Schumaker.  It
> looks like they may have been included when Anna was trying to rebase
> the rest of the branch onto v3.15-rc8?
>
> Please fix this up before asking Linus to pull your tree.
>

Thanks Stephen! We're still ironing out the kinks in a new process for
the NFS client maintenance, and appreciate your patience.

Anna, let's avoid the mess that is 3.15-rc8 for now. Please rebase on
top of commit b5968725f46d (Push the file layout driver into a
subdirectory) from my nfs-for-next branch and retag the resulting
branch using the same commit information as earlier.
I'll pull the new tag once you send the word that all is ready...

Thanks
   Trond
