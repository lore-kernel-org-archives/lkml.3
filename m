Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaLLXnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:43:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37936 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaLLXnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:43:40 -0500
Date: Sat, 13 Dec 2014 00:43:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Maintainer abuse
Message-ID: <20141212234336.GA28451@pd.tnic>
References: <alpine.DEB.2.11.1412130016090.16494@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412130016090.16494@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 12:24:03AM +0100, Thomas Gleixner wrote:
>  - Posting of massive patch sets right during or just before the merge
>    window
> 
>  - Reposting of patchsets before the reviewer/maintainer had a chance
>    to reply to ALL of N patches

Absolutely agreed.

The rule of sending out patches and collecting feedback for a week at
least is not really being respected, from my experience. Shit gets
blasted out at the highest rate possible. Maybe lkml should have a
git-send-email throttle.

And I have the sneaking impression that a lot of people have not really
understood what merge window means.

> Yours grumpy

And then they wonder why reviewers/maintainers are grumpy.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
