Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaEZRvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:51:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33798 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaEZRvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:51:49 -0400
Date: Mon, 26 May 2014 19:51:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] x86, MCE: Flesh out when to panic comment
Message-ID: <20140526175138.GB26531@pd.tnic>
References: <537D1E8B.1010505@zytor.com>
 <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com>
 <20140521215411.GI25130@pd.tnic>
 <537D21F2.8030702@zytor.com>
 <20140521221121.GL25130@pd.tnic>
 <537D2522.80702@zytor.com>
 <20140526101859.GD25732@pd.tnic>
 <alpine.LNX.2.00.1405261250230.12047@pobox.suse.cz>
 <20140526110634.GG25732@pd.tnic>
 <CALCETrVEZ3+YMP8GvmkY=scYzHuR_1sTZRFf+4rEj-4ac17PTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrVEZ3+YMP8GvmkY=scYzHuR_1sTZRFf+4rEj-4ac17PTw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 09:47:38AM -0700, Andy Lutomirski wrote:
> It may be worth at least pointing out that mce_severity looks at
> whether we faulted from kernel context. I missed that the first time
> around because mce_severity doesn't take a pt_regs pointer.

Right, but next time we talk about a different aspect which isn't
commented on in the handler, we'd have to add to it again, until we've
rewritten the whole function in pseudo code.

I think simply pointing to the function which decides the fate of the
machine based on the MCE severity is enough - people can then go and
stare at it, albeit with some struggle.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
