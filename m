Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3KLXZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:25:13 -0500
Received: from imap.thunk.org ([74.207.234.97]:57201 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab3KLXZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:25:07 -0500
Date: Tue, 12 Nov 2013 18:24:55 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: David Miller <davem@davemloft.net>
Cc: dborkman@redhat.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org,
        netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the random tree with the net-next
 tree
Message-ID: <20131112232455.GB1643@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, dborkman@redhat.com,
	sfr@canb.auug.org.au, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@stressinduktion.org,
	netdev@vger.kernel.org
References: <20131112155549.c160273993147244ed6bc81d@canb.auug.org.au>
 <5281ED01.5020204@redhat.com>
 <20131112230242.GA1643@thunk.org>
 <20131112.181717.2152470373264166279.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112.181717.2152470373264166279.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:17:17PM -0500, David Miller wrote:
> > Agreed.  What's the schedule for pushing net-dev to Linus?  I'm
> > currently at Korea Linux Forum, and I was originally planning on
> > pushing random.git to Linus sometime today, but I'm also willing to
> > wait for net-dev to go first.  Either way, we should make sure Linus
> > is aware of the agreed-upon resolution of the merge conflict.
> 
> Linus is going to pull it soon, I sent the pull request last night but
> he was away from decent internet access at the time.

Great, I'll wait for net-dev to show up in Linus's tree before I send
the pull request for random.git.

Thanks,

						- Ted

