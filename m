Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaIQMdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:33:03 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52614 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaIQMdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:33:01 -0400
Date: Wed, 17 Sep 2014 14:32:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] locking: Add WARN_ON_ONCE lock assertion
Message-ID: <20140917123256.GE2704@gmail.com>
References: <1410373899-4113-1-git-send-email-peter@hurleysoftware.com>
 <20140916080814.GA24921@gmail.com>
 <20140916181729.GB24456@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916181729.GB24456@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, Sep 16, 2014 at 10:08:14AM +0200, Ingo Molnar wrote:
> > 
> > * Peter Hurley <peter@hurleysoftware.com> wrote:
> > 
> > > An interface may need to assert a lock invariant and not flood the
> > > system logs; add a lockdep helper macro equivalent to
> > > lockdep_assert_held() which only WARNs once.
> > > 
> > > cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > 
> > Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> Any objection for me taking this through the TTY tree due to 
> the dependancies on future tty patches that use the function in 
> this patch?

Now that the patch is correct I have no objection whatsoever, 
feel free!

Thanks,

	Ingo
