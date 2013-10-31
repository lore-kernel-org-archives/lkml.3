Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3JaP34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:29:56 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:37940 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3JaP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:29:55 -0400
Date: Thu, 31 Oct 2013 11:29:50 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: WTF: driver-core-next contains recursive directory removal!
Message-ID: <20131031152950.GC11698@mtj.dyndns.org>
References: <8761sexu2l.fsf@xmission.com>
 <20131030224444.GA9092@kroah.com>
 <87a9hqp78g.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9hqp78g.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On Wed, Oct 30, 2013 at 06:19:27PM -0700, Eric W. Biederman wrote:
> The biggest and worst issue is the semantics are total unmaintable
> garbage and there has never been a single counter argument to that.
> 
> Recursive delete is WRONG.
> 
> Further there was no follow up converstion on the list about this trash
> to say you had tested it.  Or anything else.

I think you're going over the line.  You were cc'd on all patches and
all the counter points that I wrote in this thread are repetitions
from the previous threads.  I don't remember you answering to any of
the counter points.

> Even the partial recursive delete we currently have has been responsible
> for broken users of sysfs so I don't see how adding additional checks is
> going to do anything but paper over real bugs in real uses of sysfs.

Can you please go into details of what kind of bugs would be
introduced by recursive removal?  I'd really like to know and be happy
to fix any actual issues but you really aren't providing useful enough
information.

> Will you please remove that garbage from your tree. 

Eric, chill.

-- 
tejun
