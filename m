Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3HSUeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:34:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3HSUeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:34:07 -0400
Date: Mon, 19 Aug 2013 22:34:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: rfc: trivial patches and slow deaths?
In-Reply-To: <1376944033.2016.13.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1308192229360.21654@pobox.suse.cz>
References: <1376944033.2016.13.camel@joe-AO722>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013, Joe Perches wrote:

> Patches submitted to the trivial address
> trivial@kernel.org seem to go nowhere slowly.
> 
> Jiri, do you have any actual plans to try to
> pick up these patches, notify the submitters
> that the patches have been accepted or rejected,
> and forward them on when appropriate?
> 
> Otherwise, the patches sit for _months_ without
> any action.  That's simply too long.
> 
> Should another mechanism or pathway be created
> instead?

Joe,

I disagree. Please look at what is happening in trivial.git over longer 
period of time.

The patches I am holding off are larger series which are submitted both to 
trivial@ and maintainers as well. With such pathces, it's not clear who is 
taking (which parts of) what, hence I hold them off for long time, and get 
back to it eventually later.

It's time consuming, as I have to check linux-next for those patches, 
hence it's delayed.

One-shot single trivial patches are picked up reasonably fast (i.e. are 
very rarely delayed for one Linus' release).

But yes, I agree, you are usually sending cross-tree large patchsets, and 
therefore you are often affected by what you describe.

Perhaps if you send to trivial@ only those patches which haven't been 
picked up by maintainers already, that'd lead to much faster application 
of those, if that's what you are about.

-- 
Jiri Kosina
SUSE Labs
