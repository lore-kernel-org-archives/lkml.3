Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbbAUFeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:34:16 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:37533 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbAUFeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:34:15 -0500
Date: Wed, 21 Jan 2015 06:34:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Fwd: linux-next: manual merge of the luto-misc tree with the tip
 tree
Message-ID: <20150121053410.GA15291@gmail.com>
References: <20150119170839.2c6b4b78@canb.auug.org.au>
 <20150119093501.GA4644@pd.tnic>
 <CALCETrW05f9nty5Sk8XA2DTsocqqOxp62aT9QXwta74Km+ZOng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW05f9nty5Sk8XA2DTsocqqOxp62aT9QXwta74Km+ZOng@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> Hi Ingo and Thomas-
> 
> There's a trivial conflict in the pull request I sent last week.

This is your x86 entry code rework pull request, right? The -tip 
tree now has the RCU commit it depends on, so could you please 
rebase it on top of tip:core/rcu so I can pull it? I'll resolve 
any remaining conflicts with the rest of -tip.

Thanks,

	Ingo
