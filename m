Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3JJLkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:40:51 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47513 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3JJLks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:40:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19YoEBqBgGbj+o7cgbIo6SSBsr9Ij0BYOw=
Date: Thu, 10 Oct 2013 07:40:46 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the mvebu tree
Message-ID: <20131010114046.GE5402@titan.lakedaemon.net>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
 <1381328067-1593-6-git-send-email-treding@nvidia.com>
 <20131009143727.GD5402@titan.lakedaemon.net>
 <20131010105702.GD6735@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010105702.GD6735@ulmo.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 12:57:03PM +0200, Thierry Reding wrote:
> On Wed, Oct 09, 2013 at 10:37:27AM -0400, Jason Cooper wrote:
> > Thierry,
> > 
> > On Wed, Oct 09, 2013 at 04:14:27PM +0200, Thierry Reding wrote:
> > > Today's linux-next merge of the mvebu tree got conflicts in
> > 
> > I looked in your scripts repo, and couldn't find the script you use to
> > send out this email thread :( 
> 
> Well, that's because I'm doing them manually.

:)  Nice.  I do like the threading, it provides a nice consolidated
summary of the day's tree.

> > Since I can't create a patch, I'll just ask, could you include the
> > commit id of the branch you pulled in the email?
> > 
> > eg:
> > 
> > Today's linux-next merge of the mvebu tree (477cdaf) got conflicts in
> > ...
> > 
> > I had uploaded a new for-next branch less than 30 minutes before you
> > sent this out, so I wasn't sure which you were working with.  Not a big
> > deal, just thought I'd pass along the idea for the next time you're
> > tweaking your scripts.
> 
> It should be possible to extend the Next/fetch script with something
> that writes the SHA1 of each tree to a file. Stephen's linux-next trees
> contain such a file (Next/SHA1s). I'll see if I can find the time to
> update my scripts to do the same. That won't make it magically appear in
> the notification email, but I can probably remember to do that in the
> future.

No, not necessary.  I don't want to add unnecessary work to your plate.
If the script modification put it in the email notification
automagically, it might be worth doing, but if a tree owner is already
looking at your -next tree, it's trivial to go one step further and look
at the merge commit (which is what I did in this case).

thanks, and sorry for the noise.

Jason.
