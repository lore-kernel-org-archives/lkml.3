Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741AbaGXVp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 17:45:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60413 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759583AbaGXVpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 17:45:55 -0400
Date: Thu, 24 Jul 2014 23:45:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Linux 3.16-rc6
Message-ID: <20140724214549.GU19239@pd.tnic>
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
 <20140723095327.GA23131@pd.tnic>
 <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com>
 <20140724064353.GW9918@twins.programming.kicks-ass.net>
 <20140724084126.GB19239@pd.tnic>
 <20140724122513.GM19239@pd.tnic>
 <20140724125814.GX6758@twins.programming.kicks-ass.net>
 <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com>
 <20140724183643.GM3935@laptop>
 <53D16EC4.1000801@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53D16EC4.1000801@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:38:28PM -0400, Waiman Long wrote:
> Borislav, can you apply the following patch on top of the lockdep
> patch to see if it can fix the problem?

It is too late here for me to test anything but the ingridients to
reproduce are nothing special. Just grab a kvm guest and pick out the
locking or so options out of the .config I sent previously. Then boot it
a couple of times, it triggers pretty easy after a couple of tries.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
