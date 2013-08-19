Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3HSViy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:38:54 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59531 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121Ab3HSVix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:38:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19qkiKtqWW93WwDueUTjIg91BzoPohyWxk=
Date: Mon, 19 Aug 2013 17:38:33 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the mvebu tree with the arm-soc
 tree
Message-ID: <20130819213833.GB13964@titan.lakedaemon.net>
References: <20130819160537.1eeb0a9ebc269def138e016b@canb.auug.org.au>
 <20130819205736.GA13964@titan.lakedaemon.net>
 <CAOesGMhRo1X=w=2-pKNz-eXiviWg3aqtVyW=f43RfigTS4dRmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhRo1X=w=2-pKNz-eXiviWg3aqtVyW=f43RfigTS4dRmg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 02:09:00PM -0700, Olof Johansson wrote:
> it's this commit:
> 
> commit 89602312c5755c87a5ca6ba8ef6b0fce9d510951
> Merge: a0cec78 f23afe2
> Author:     Jason Cooper <jason@lakedaemon.net>
> AuthorDate: Wed Aug 14 18:55:13 2013 +0000
> Commit:     Jason Cooper <jason@lakedaemon.net>
> CommitDate: Wed Aug 14 18:55:13 2013 +0000
> 
>     Merge remote-tracking branch 'arm-soc/for-next' into mvebu/drivers
> 

grmbl... Yep, that's my mistake.  I usually do a temp branch for
merge-testing against arm-soc/for-next and building.  Apparently I
forgot to make the branch first.  My apologies.

I've fixed up mvebu/drivers, and I'm build testing a rebuilt for-next
now.

> You merged back the for-next branch from arm-soc into your tree. Big no-no.

Yep, \shame/.

> This brings up the subject of subplatform trees and conflicts and
> -next. I wonder if we should ask Stephen to put all these trees in a
> category where if they have any substantial conflicts or weirdness
> like this, that he just drops it for the current -next build instead
> of spending effort on them.

Agreed.  A tree hierarchy of sorts.  mvebu and other sub-arch trees
should definitely be dropped for the day with minimal investigation.

thx,

Jason.
