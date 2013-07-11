Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3GKNfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:35:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab3GKNfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:35:42 -0400
Date: Thu, 11 Jul 2013 09:35:11 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Hannes Reinecke <hare@suse.de>, Jim Ramsay <jim_ramsay@dell.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Robin Dong <sanbai@taobao.com>, stable@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>, axboe@kernel.dk
Subject: Re: [git pull] device-mapper changes for 3.11
Message-ID: <20130711133511.GA12287@redhat.com>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com>
 <20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11 2013 at  2:20am -0400,
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Thu, 11 Jul 2013 02:34:48 +0100 Alasdair G Kergon <agk@redhat.com> wrote:
> >
> > Please pull from:
> >  
> >   git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.11-changes
> > 
> > to get the following device-mapper changes for 3.11.
> 
> The device-mapper tree exists as a quilt series in linux-next.  The
> patches in the above git tree are the same as the ones in linux-next, but
> have a different base (and the ones in linux-next were on a different
> base from yesterday as well). :-(
> 
> Alistair, is there some reason that you cannot maintain some relatively
> stable git tree for me to fetch (instead of the quilt series).  Also,
> there is not real reason to keep rebasing this stuff (especially just
> before sending it to Linus).

Hi Stephen,

I'll be transitioning in to maintain device mapper (for 3.12).  Alasdair
will be helping me as needed but ultimately the plan is for me to be the
one sending DM changes upstream in the future.  I will maintain a
kernel.org git tree with a 'for-next' branch for you to pull.  I'll
likely base my for-next on Jens' for-next as a rule (unless that isn't
ideal on a linux-next process level).

There will be a learning curve for me initially on how to interface with
linux-next, proper git rebase protocol relative to Linus' ideals, etc
but I hope to cut through that quickly.

Regards,
Mike
