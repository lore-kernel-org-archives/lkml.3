Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaGOHoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:44:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55540 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932438AbaGOHoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:44:16 -0400
X-Sasl-enc: Rrs7eZSXXx0+VuiednD2zCmP/7yeiI5sScF7IfeKdJ1M 1405410253
Message-ID: <1405410251.3219.4.camel@perseus.fritz.box>
Subject: Re: [PATCH 4/6 v2] autofs4: factor should_expire() out of
 autofs4_expire_indirect.
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 15 Jul 2014 15:44:11 +0800
In-Reply-To: <20140715140502.5e7f1da0@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <20140709234114.4525.25725.stgit@notabene.brown>
	 <20140714105359.4415aab4@notabene.brown>
	 <1405396113.3112.17.camel@perseus.fritz.box>
	 <20140715140502.5e7f1da0@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 14:05 +1000, NeilBrown wrote:
> On Tue, 15 Jul 2014 11:48:33 +0800 Ian Kent <raven@themaw.net> wrote:
> ...
> > So far I've tracked this to something that was introduced between 3.11
> > and 3.12. One change that went into 3.12 was Jeff Laytons' umount
> > specific path resolution for umount. I've found this is also broken on
> > recent RHEL-6 kernels and that change is present in them too so the
> > evidence is leaning toward that being the problem. Just how could happen
> > with this change I have no clue so far, it just doesn't make sense.
> 
> Such a familiar story!  I've not yet failed to find bugs like that, but
> sometimes it takes a looooong time.  Good luck!
> 
> > 
> > Anyway that's going to make testing these patches impossible until I can
> > work out what the problem is and fix it.
> > 
> > Very sorry to hold you up on this but it can't be avoided. 
> 
> Thanks a lot for letting me know the situation!
> While I always appreciate upstream review I've learnt not to depend on it.
> I'll proceed with my customers based on my judgement and look forward to any
> input you can provide whenever you are able to provide it.

Yeah, I planed to spend some time to have a look on Wednesday and still
will but, as I say, testing is going to take more time than I have just
now.

Usual autofs usage rarely, if ever, uses symlinks so your customers
should be fine but be aware of the difficulty if you run into people
that want to use amd maps.

> 
> Thanks,
> NeilBrown


