Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3BCTG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:06:29 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60930 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3BCTG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:06:27 -0500
Date: Sun, 3 Feb 2013 20:06:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Artem Savkov <artem.savkov@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asmlinkage tag for sys_iopl
Message-ID: <20130203190623.GA23021@gmail.com>
References: <1359895582-5482-1-git-send-email-artem.savkov@gmail.com>
 <20130203185912.GA22895@gmail.com>
 <20130203190435.GS4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130203190435.GS4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

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
> It's in signal.git; proper fix is to use SYSCALL_DEFINE1().  
> I'll push it tonight.

Thanks!

	Ingo
