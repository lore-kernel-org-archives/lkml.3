Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaEZLGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:06:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36483 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaEZLGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:06:44 -0400
Date: Mon, 26 May 2014 13:06:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] x86, MCE: Flesh out when to panic comment
Message-ID: <20140526110634.GG25732@pd.tnic>
References: <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com>
 <20140521214319.GF25130@pd.tnic>
 <537D1E8B.1010505@zytor.com>
 <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com>
 <20140521215411.GI25130@pd.tnic>
 <537D21F2.8030702@zytor.com>
 <20140521221121.GL25130@pd.tnic>
 <537D2522.80702@zytor.com>
 <20140526101859.GD25732@pd.tnic>
 <alpine.LNX.2.00.1405261250230.12047@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405261250230.12047@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 12:51:10PM +0200, Jiri Kosina wrote:
> I think the comment is still not explaining the big part of what the
> discussion was about -- i.e. if it was in kernel context, we always
> panic.

I thought the pointer to mce_severity was enough? People should open an
editor and look at the function and at its gory insanity. :-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
