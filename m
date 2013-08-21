Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3HUBga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:36:30 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:63301 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3HUBg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:36:29 -0400
Date: Tue, 20 Aug 2013 20:36:27 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: rfc: trivial patches and slow deaths?
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
References: <1377043822.2737.86@driftwood>
	<1377044556.2016.102.camel@joe-AO722>
In-Reply-To: <1377044556.2016.102.camel@joe-AO722> (from joe@perches.com on
	Tue Aug 20 19:22:36 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377048987.2737.89@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 07:22:36 PM, Joe Perches wrote:
> On Tue, 2013-08-20 at 19:10 -0500, Rob Landley wrote:
> > The important question is does he want to handle patches that you're
> > flipping out about not going in before the next merge window because
> > they are SO IMPORTANT that the trivial tree must promote them out of
> > sequence.
> 
> You're misreading.  I see no flipping out here.
> 
> I'm simply saying that obvious defects should be
> corrected sooner rather than later.
> 
> I'm also saying that the trivial tree should
> have some visibility about whether or not a
> patch or series will be handled by the trivial
> maintainer or not.

I fetch his git and look at the log of the branch to see which of the  
documentation patches I forwarded are there. That said, there's no  
guarantee they'll go in from there because other maintainers often grab  
them and put them in through their trees.

> Jiri has not responded to this point.

He did. Twice.

> Silence about the status of patches that extends
> for months is not good.

He has a public git tree. It's listed in his MAINTAINERS entry. I've  
found that if a patch isn't in there, he hasn't picked it up yet. (I've  
been feeding Documentation patches through his tree, hence my interest  
in this thread.)

Rob