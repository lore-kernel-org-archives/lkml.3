Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab3KRWkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:40:15 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301Ab3KRWkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:40:11 -0500
From: Richard Weinberger <richard@nod.at>
To: Joe Perches <joe@perches.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, apw@canonical.com,
        bp@alien8.de
Subject: Re: [PATCH] checkpatch.pl: Check for functions without a real prototype
Date: Mon, 18 Nov 2013 23:40:05 +0100
Message-ID: <1823702.CebDozRkek@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.9.8-15.gf3348a8-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1384814182.17783.5.camel@joe-AO722>
References: <1384813914-11491-1-git-send-email-richard@nod.at> <1384814182.17783.5.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 18. November 2013, 14:36:22 schrieb Joe Perches:
> On Mon, 2013-11-18 at 23:31 +0100, Richard Weinberger wrote:
> > Functions like this one are evil:
> > 
> > void foo()
> > {
> > 
> > 	...
> > 
> > }
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > CC: hpa@zytor.com
> 
> I won't take simple resubmissions without updating
> based on the notes I gave you.

Of course. I managed it to send the *old* patch file.
Will resend in a minute...

> And now, this should be updated to allow --fix use too.
> 
> I'll take care of it instead.

Thanks,
//richard
