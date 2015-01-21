Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854AbbAUFtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:49:00 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:53670 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUFs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:48:59 -0500
MIME-Version: 1.0
In-Reply-To: <20150121053410.GA15291@gmail.com>
References: <20150119170839.2c6b4b78@canb.auug.org.au> <20150119093501.GA4644@pd.tnic>
 <CALCETrW05f9nty5Sk8XA2DTsocqqOxp62aT9QXwta74Km+ZOng@mail.gmail.com> <20150121053410.GA15291@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Jan 2015 21:48:36 -0800
Message-ID: <CALCETrXCenu4UexZfV6HTq898JbXmZGU5KaCWCXrz7oikrA34g@mail.gmail.com>
Subject: Re: Fwd: linux-next: manual merge of the luto-misc tree with the tip tree
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 9:34 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@amacapital.net> wrote:
>
>> Hi Ingo and Thomas-
>>
>> There's a trivial conflict in the pull request I sent last week.
>
> This is your x86 entry code rework pull request, right? The -tip
> tree now has the RCU commit it depends on, so could you please
> rebase it on top of tip:core/rcu so I can pull it? I'll resolve
> any remaining conflicts with the rest of -tip.
>

Sure, I can do that in the morning.  The pull request merges cleanly
with tip:core/rcu, though, so is the rebase needed?

--Andy
