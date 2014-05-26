Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaEZQsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:48:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44464 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaEZQr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:47:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140526110634.GG25732@pd.tnic>
References: <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com>
 <20140521214319.GF25130@pd.tnic> <537D1E8B.1010505@zytor.com>
 <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com>
 <20140521215411.GI25130@pd.tnic> <537D21F2.8030702@zytor.com>
 <20140521221121.GL25130@pd.tnic> <537D2522.80702@zytor.com>
 <20140526101859.GD25732@pd.tnic> <alpine.LNX.2.00.1405261250230.12047@pobox.suse.cz>
 <20140526110634.GG25732@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 May 2014 09:47:38 -0700
Message-ID: <CALCETrVEZ3+YMP8GvmkY=scYzHuR_1sTZRFf+4rEj-4ac17PTw@mail.gmail.com>
Subject: Re: [PATCH] x86, MCE: Flesh out when to panic comment
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 4:06 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, May 26, 2014 at 12:51:10PM +0200, Jiri Kosina wrote:
>> I think the comment is still not explaining the big part of what the
>> discussion was about -- i.e. if it was in kernel context, we always
>> panic.
>
> I thought the pointer to mce_severity was enough? People should open an
> editor and look at the function and at its gory insanity. :-P

It may be worth at least pointing out that mce_severity looks at
whether we faulted from kernel context.  I missed that the first time
around because mce_severity doesn't take a pt_regs pointer.

--Andy
