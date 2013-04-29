Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3D2PSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab3D2PSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:18:45 -0400
Date: Mon, 29 Apr 2013 11:17:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, scameron@beardog.cce.hp.com, axboe@kernel.dk,
        neilb@suse.de, hch@infradead.org, jmoyer@redhat.com,
        stephenmcameron@gmail.com, linux-kernel@vger.kernel.org,
        lsorense@csclub.uwaterloo.ca
Subject: Re: [RFC PATCH] block: Add new generic block device naming interface
Message-ID: <20130429151719.GG8204@redhat.com>
References: <20130425202215.20557.75283.stgit@beardog.cce.hp.com>
 <20130425204033.GB10990@mtj.dyndns.org>
 <20130425210726.GL7917@beardog.cce.hp.com>
 <20130425211459.GC10990@mtj.dyndns.org>
 <20130425221220.GM7917@beardog.cce.hp.com>
 <20130426190327.GC1433@mtj.dyndns.org>
 <517E8A26.7060705@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517E8A26.7060705@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 04:56:38PM +0200, Hannes Reinecke wrote:
> On 04/26/2013 09:03 PM, Tejun Heo wrote:
> > hey,
> > 
> > On Thu, Apr 25, 2013 at 05:12:20PM -0500, scameron@beardog.cce.hp.com wrote:
> >> It looks like these are called from a function called init_device_map() 
> >> that is called from grub_stage2() at least in the version of grub I looked
> >> at (0.97, from rhel6).
> >>
> >> So my assumption is that adding a new block driver with yet another name space
> >> would require adding another bit of code into grub like those above.  When I
> >> asked about "best practices" for new block driver device names on the grub devel
> >> mailing list to minimize required changes to grub, nobody argued against that
> >> assumption. 
> > 
> > I think we kinda need to get down to the root cause of the issue.
> > Nothing against giving common names to devices in itself but there's a
> > non-insigificant chance that we end up with something half-way if the
> > original problem isn't properly understodd.
> > 
> Oh, the problem _is_ well understood.
> 
> It's the design of grub :-)
> 
> grub requires you to re-implement _every_ device naming scheme which
> is present in the kernel.

So then grub needs to be fixed and not the other way around?

Thanks
Vivek
