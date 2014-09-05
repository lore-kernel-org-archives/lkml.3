Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaIEVpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:45:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55626 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbaIEVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:45:34 -0400
X-Sasl-enc: 8n0NYRJKs2FliWB0ZZhLckNlZc8y3gYm4sDuHQ7XhVne 1409953533
Date: Fri, 5 Sep 2014 14:45:32 -0700
From: Greg KH <greg@kroah.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Peter Kieser <peter@kieser.ca>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
Message-ID: <20140905214532.GA30221@kroah.com>
References: <20140805043346.GF541@moria.home.lan>
 <53E10D48.1010700@kernel.dk>
 <53E7251B.3080305@kieser.ca>
 <540966BA.9030106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540966BA.9030106@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 09:31:06AM +0200, Francis Moreau wrote:
> On 08/10/2014 09:54 AM, Peter Kieser wrote:
> > 
> > On 2014-08-05 9:58 AM, Jens Axboe wrote:
> >> On 08/04/2014 10:33 PM, Kent Overstreet wrote:
> >>> Hey Jens, here's the pull request for 3.17 - typically late, but lots of tasty
> >>> fixes in this one :)
> >> Normally I'd say no, but since it's basically just fixes, I guess we can
> >> pull it in. But generally, it has to be in my hands a week before this,
> >> so it can simmer a bit in for-next before going in...
> >>
> > Are these fixes going to be backported to 3.10 or other stable releases?
> > 
> 
> Could you please answer this question ?
> 
> If you don't want to maintain bcache for stable kernels (I can
> understand that), can you mark it at least as unstable/experimental
> stuff since it really is ?

WTF?

Just because a maintainer/developer doesn't want to do anything for the
stable kernel releases does _NOT_ mean the code is
"unstable/expreimental" at all.

That's not how stable kernel releases work.  _IF_ a maintainer wants to
/ has the time to, they can mark patches for inclusion in stable kernel
releases.  Given the huge list of patches that Jens just posted, I doubt
that those are really something I would ever take for a stable kernel
release.

Please read Documentation/stable_kernel_rules.txt for more details
please.  And don't ask others to do backporting work for you, it's not
ok, and is something that I have always said is never required, and is
not going to be.

thanks,

greg k-h
