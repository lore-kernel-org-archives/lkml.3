Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaEAL6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:58:20 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:20918 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaEAL6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:58:18 -0400
X-Nat-Received: from [202.181.97.72]:52964 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1398945493.1441
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH (for 3.15) 0/5] Fix cross rename race window for LSM.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
	<53523D16.9020101@gmail.com>
	<201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
	<CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
	<201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
In-Reply-To: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
Message-Id: <201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 1 May 2014 20:58:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 01052014 #7829213, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James, would you send this patchset to Linus?
This patchset is expected to go to 3.15 because this is a kind of regression fix.

Tetsuo Handa wrote:
> Miklos Szeredi wrote:
> > On Sat, Apr 19, 2014 at 2:08 PM, Tetsuo Handa
> > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > Michael Kerrisk (man-pages) wrote:
> > >> Now that renameat2() is in 3.15, I've taken these changes.
> > >
> > > What!? I didn't know renameat2() goes to 3.15.
> > >
> > > But I assume that renameat2() is not accessible in 3.15, for I can see
> > > "asmlinkage long sys_renameat2(" but don't see "#define __NR_renameat2".
> > 
> > x86 automatically generates __NR_foo entries and syscall tables from
> > arch/x86/syscalls/syscall_*.tbl, which is why you don't find an
> > explicit definition in the git tree.
> > 
> > Thanks,
> > Miklos
> > 
> 
> Oh, I see. Then, I must submit patches for fixing a race window
> caused by commit da1ce067 "vfs: add cross-rename".
> 
> Regards.
> 
