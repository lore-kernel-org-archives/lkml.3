Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3BDPVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:21:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38579 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3BDPVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:21:45 -0500
Date: Mon, 4 Feb 2013 15:21:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asmlinkage tag for sys_iopl
Message-ID: <20130204152141.GB4503@ZenIV.linux.org.uk>
References: <1359895582-5482-1-git-send-email-artem.savkov@gmail.com>
 <20130203185912.GA22895@gmail.com>
 <20130203190435.GS4503@ZenIV.linux.org.uk>
 <20130203194422.GA3990@thinkpad.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130203194422.GA3990@thinkpad.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 11:44:22PM +0400, Artem Savkov wrote:
> On Sun, Feb 03, 2013 at 07:04:35PM +0000, Al Viro wrote:
> > On Sun, Feb 03, 2013 at 07:59:12PM +0100, Ingo Molnar wrote:
> > > 
> > > * Artem Savkov <artem.savkov@gmail.com> wrote:
> > > 
> > > > asmlinkage tag seems to be missing from sys_iopl prototype rendering iopl
> > > > syscalls unusable, i.e. every call returns -EINVAL. Most likely introduced in
> > > > 9e0b2428bc6a6c6df90bb701ca843820727cadf0.
> > > 
> > > What commit is 9e0b2428bc6a6c6df90bb701ca843820727cadf0? It's 
> > > certainly not upstream nor in the x86 tree.
> > 
> > It's in signal.git; proper fix is to use SYSCALL_DEFINE1().  I'll push it
> > tonight.
> 
> It is also in linux-next.git, so it would be nice to have a fix merged
> there too.
> Thanks.

linux-next pulls signal.git, which is how that commit has appeared there
in the first place...
