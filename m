Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaFRVgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:36:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbaFRVgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:36:22 -0400
Date: Wed, 18 Jun 2014 23:35:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] floppy
In-Reply-To: <53A1CC9E.1060308@kernel.dk>
Message-ID: <alpine.LNX.2.00.1406182334530.2303@pobox.suse.cz>
References: <alpine.LNX.2.00.1406181406401.2303@pobox.suse.cz> <53A1CC9E.1060308@kernel.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Jens Axboe wrote:

> > please pull from
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git
> > for-jens
> > 
> > to receive formatting fix for floppy driver; preferably for 3.16 still.
> > The branch is based on your for-3.16/drivers.
> 
> I'll queue it up for 3.16. Just sent out a pull request, but I'm sure there
> will be a later one in this cycle as well.

Ah, now I see I just raced with your pull request. I can resend it again 
in a couple of days if you wish.

And, if it ends up in 3.17, no harm caused really (which is true for 
almost any patch to floppy driver anyway :) ).

Thanks,

-- 
Jiri Kosina
SUSE Labs
