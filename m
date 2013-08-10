Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537Ab3HJQKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:10:34 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35845 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934372Ab3HJQKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:10:33 -0400
Date: Sat, 10 Aug 2013 18:10:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/13] x86: Move cond resched for copy_{from,to}_user
 into low level code 64bit
Message-ID: <20130810161031.GK19750@two.firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
 <1376089460-5459-11-git-send-email-andi@firstfloor.org>
 <CA+55aFyN2Cnt=uQOnXszwDA971o=xEwO=yFSgL-RH9vRjMsBbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyN2Cnt=uQOnXszwDA971o=xEwO=yFSgL-RH9vRjMsBbg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Most of this series looks fine, but I really think that we
> could/should just take that extra step, and say "no, user accesses
> don't imply that we need to check for scheduling".

Hmm. I can do that, but wouldn't that make CONFIG_PREEMPT_VOLUNTARY
mostly equivalent to CONFIG_PREEMPT_NONE?

Need to check how many other reschedule tests are left then for VOLUNTARY.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
