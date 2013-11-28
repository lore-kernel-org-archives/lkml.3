Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab3K1JNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:13:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab3K1JNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:13:01 -0500
Date: Thu, 28 Nov 2013 10:12:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
In-Reply-To: <CA+55aFw2RANS0j5zjfKhbejYpoLe5Z9VnPudb+AouzA242LJJg@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1311281009580.9932@twin.jikos.cz>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com> <52964EC7.9000504@zytor.com> <52966C0A.7070201@zytor.com>
 <CA+55aFzr9ZKcGfT_Q31T9_vuCcmWxGCh0wixuZqt7VhjxxYU9g@mail.gmail.com> <529677D7.9080203@zytor.com> <CA+55aFx9mXy3VASfek5052GTbiUVSgBVsRwnF4cse1dc=z70HQ@mail.gmail.com> <52968018.5090907@zytor.com>
 <CA+55aFw2RANS0j5zjfKhbejYpoLe5Z9VnPudb+AouzA242LJJg@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Linus Torvalds wrote:

> But is such batching really even worth it? If' it's not *that* much more 
> effort, maybe it's worth it, but do we have known users that really 
> would have thousands and thousands of cases all at once?

If you want to base tracing infrastructure on it, then you might easily 
want to patch all the existing functions. We have in-kernel facility 
(ftrace) doing exactly that.

-- 
Jiri Kosina
SUSE Labs

