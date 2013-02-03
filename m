Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3BCTo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:44:28 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:53350 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3BCTo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:44:26 -0500
Date: Sun, 3 Feb 2013 23:44:22 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asmlinkage tag for sys_iopl
Message-ID: <20130203194422.GA3990@thinkpad.lan>
References: <1359895582-5482-1-git-send-email-artem.savkov@gmail.com>
 <20130203185912.GA22895@gmail.com>
 <20130203190435.GS4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130203190435.GS4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 07:04:35PM +0000, Al Viro wrote:
> On Sun, Feb 03, 2013 at 07:59:12PM +0100, Ingo Molnar wrote:
> > 
> > * Artem Savkov <artem.savkov@gmail.com> wrote:
> > 
> > > asmlinkage tag seems to be missing from sys_iopl prototype rendering iopl
> > > syscalls unusable, i.e. every call returns -EINVAL. Most likely introduced in
> > > 9e0b2428bc6a6c6df90bb701ca843820727cadf0.
> > 
> > What commit is 9e0b2428bc6a6c6df90bb701ca843820727cadf0? It's 
> > certainly not upstream nor in the x86 tree.
> 
> It's in signal.git; proper fix is to use SYSCALL_DEFINE1().  I'll push it
> tonight.

It is also in linux-next.git, so it would be nice to have a fix merged
there too.
Thanks.

-- 
Kind regards,
Artem
