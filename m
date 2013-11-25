Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3KYLC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:02:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35328 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab3KYLCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:02:55 -0500
Date: Mon, 25 Nov 2013 12:02:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Johannes =?utf-8?B?TMO2dGhiZXJn?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
Message-ID: <20131125110251.GC6782@pd.tnic>
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
 <528ACB6A.1040809@zytor.com>
 <20131119072241.GB32478@gmail.com>
 <20131119103408.GA3640@pd.tnic>
 <1384883323.17783.35.camel@joe-AO722>
 <20131119182306.GD3515@pd.tnic>
 <528BACCB.1090604@zytor.com>
 <1384885733.17783.37.camel@joe-AO722>
 <20131125101807.GA13385@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131125101807.GA13385@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 11:18:07AM +0100, Ingo Molnar wrote:
> If a newbie does a meaningful, complete, well done cleanup patch then
> congratulations and any such help is welcome.
>
> If you as a more experienced kernel developer do a cleanup as part of
> some real work then sure, all such cleanups are welcome and they are a
> natural part of development work.
>
> So a standalone cleanup patch to a20.c from _you_ would probably not
> qualify, almost by definition: your first patch was applied 7 years
> ago, you are by far not a newbie anymore, yet you seem to be mostly
> stuck on the 'cleanups and trivialities' level! Sheesh!
>
> My message to the buerocrat Joe Perches is: please leave trivial and
> printk patches to newbies, you need to raise to the next level of
> kernel development already.
>
> FYI, Linux is a meritocracy, not a bureaucracy: creating self-serving
> churn and attention-seeking but unimportant patches is not the way to
> gain kernel development credibility long term, and eventually people
> start protecting against your increasing abuse of the development
> process. IMHO.

... and not only that - sending patches to the kernel shouldn't be about
the *sending* of patches itself but actually about doing some real
improvement to it.

Thanks Ingo for hitting the nail on the head!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
