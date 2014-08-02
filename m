Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaHCREp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 13:04:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39473 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbaHCREk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 13:04:40 -0400
X-Sasl-enc: pvQ7/I417PPP4NJ0yfAUHFK8SUz0X4bAyeGzeXsvzvrt 1407085475
Date: Fri, 1 Aug 2014 19:40:38 -0700
From: Greg KH <greg@kroah.com>
To: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Riley <davidriley@chromium.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the tip
 tree
Message-ID: <20140802024038.GB22728@kroah.com>
References: <20140731170735.5cf2062b@canb.auug.org.au>
 <20140801002017.GA2945@kroah.com>
 <CAGXu5jKD5X4ZZreierjWsB659pXJgc9eXJX==Wm+-R22nKY+xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKD5X4ZZreierjWsB659pXJgc9eXJX==Wm+-R22nKY+xQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 07:38:26PM -0400, Kees Cook wrote:
> On Thu, Jul 31, 2014 at 8:20 PM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Jul 31, 2014 at 05:07:35PM +1000, Stephen Rothwell wrote:
> >> Hi Greg,
> >>
> >> Today's linux-next merge of the driver-core tree got a conflict in
> >> lib/Kconfig.debug between commit e704f93af5a0 ("kernel: time: Add
> >> udelay_test module to validate udelay") from the tip tree and commit
> >> 0a8adf584759 ("test: add firmware_class loader test") from the
> >> driver-core tree.
> >>
> >> I fixed it up (see below) and can carry the fix as necessary (no action
> >> is required).
> >
> > Looks good, thanks.
> 
> For keeping things regularized, could this module instead be named
> "test_udelay", to match the rest of most of the test modules?
> (Starting with "test_".)

Makes sense, want to send a patch to rename it?

thanks,

greg k-h
