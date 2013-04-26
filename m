Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3DZTDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:03:40 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51165 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab3DZTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:03:39 -0400
Date: Fri, 26 Apr 2013 12:03:33 -0700
From: Tejun Heo <tj@kernel.org>
To: scameron@beardog.cce.hp.com
Cc: axboe@kernel.dk, neilb@suse.de, hch@infradead.org, jmoyer@redhat.com,
        hare@suse.de, vgoyal@redhat.com, stephenmcameron@gmail.com,
        linux-kernel@vger.kernel.org, lsorense@csclub.uwaterloo.ca
Subject: Re: [RFC PATCH] block: Add new generic block device naming interface
Message-ID: <20130426190327.GC1433@mtj.dyndns.org>
References: <20130425202215.20557.75283.stgit@beardog.cce.hp.com>
 <20130425204033.GB10990@mtj.dyndns.org>
 <20130425210726.GL7917@beardog.cce.hp.com>
 <20130425211459.GC10990@mtj.dyndns.org>
 <20130425221220.GM7917@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425221220.GM7917@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hey,

On Thu, Apr 25, 2013 at 05:12:20PM -0500, scameron@beardog.cce.hp.com wrote:
> It looks like these are called from a function called init_device_map() 
> that is called from grub_stage2() at least in the version of grub I looked
> at (0.97, from rhel6).
> 
> So my assumption is that adding a new block driver with yet another name space
> would require adding another bit of code into grub like those above.  When I
> asked about "best practices" for new block driver device names on the grub devel
> mailing list to minimize required changes to grub, nobody argued against that
> assumption. 

I think we kinda need to get down to the root cause of the issue.
Nothing against giving common names to devices in itself but there's a
non-insigificant chance that we end up with something half-way if the
original problem isn't properly understodd.

Thanks.

-- 
tejun
