Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3KYKSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:18:14 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41382 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3KYKSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:18:12 -0500
Date: Mon, 25 Nov 2013 11:18:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Johannes =?iso-8859-1?Q?L=F6thberg?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
Message-ID: <20131125101807.GA13385@gmail.com>
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
 <528ACB6A.1040809@zytor.com>
 <20131119072241.GB32478@gmail.com>
 <20131119103408.GA3640@pd.tnic>
 <1384883323.17783.35.camel@joe-AO722>
 <20131119182306.GD3515@pd.tnic>
 <528BACCB.1090604@zytor.com>
 <1384885733.17783.37.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384885733.17783.37.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Tue, 2013-11-19 at 10:24 -0800, H. Peter Anvin wrote:
>
> > I'll take a proper cleanup,
> > but just whitespace... just pointless churn.
> 
> What in your view would be "a proper cleanup" for a20.c?

If a newbie does a meaningful, complete, well done cleanup patch then 
congratulations and any such help is welcome.

If you as a more experienced kernel developer do a cleanup as part of 
some real work then sure, all such cleanups are welcome and they are a 
natural part of development work.

So a standalone cleanup patch to a20.c from _you_ would probably not 
qualify, almost by definition: your first patch was applied 7 years 
ago, you are by far not a newbie anymore, yet you seem to be mostly 
stuck on the 'cleanups and trivialities' level! Sheesh!

My message to the buerocrat Joe Perches is: please leave trivial and 
printk patches to newbies, you need to raise to the next level of 
kernel development already.

FYI, Linux is a meritocracy, not a bureaucracy: creating self-serving 
churn and attention-seeking but unimportant patches is not the way to 
gain kernel development credibility long term, and eventually people 
start protecting against your increasing abuse of the development 
process. IMHO.

Thanks,

	Ingo
