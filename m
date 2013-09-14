Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3INLOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 07:14:34 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:35181 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3INLOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 07:14:30 -0400
Date: Sat, 14 Sep 2013 15:14:26 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: proc hidepid=2 and SGID programs
Message-ID: <20130914111426.GB4663@cachalot>
References: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org>
 <87r4cybio2.fsf@xmission.com>
 <alpine.DEB.2.11.1309100124020.6509@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1309100124020.6509@trent.utfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 01:30 -0700, Christian Kujau wrote:
> On Sun, 8 Sep 2013 at 23:42, Eric W. Biederman wrote:
> > I don't have a clue why anyone would want to hide processes, and make
> > their own lives more difficult.
> 
> Oh, there are plenty of usescases, I'm sure. And I for one am thankful 
> that this process hiding option made it into the kernel. Or, to answer in 
> another way: why would anyone want to see other peoples processes?

The point is that quite many information about other user processes
which can be obtained from procfs can be used in side channel attacks
directed to either confidentiality or even privilege escalation.

> > The check with hidepid is can you ptrace the process.  I expect there
> > is something with those sgid processes that keeps you from ptracing
> > them.
> 
> Indeed, I cannot strace the process.

Right.

> But still, I wonder if this is 
> intended behaviour.

Yes.

If you think such side channel attacks are something you don't care,
just turn hidepid off.  That's why it is an option.

If you want to turn it off for some users, use gid=XXX.

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
