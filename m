Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3KDUQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:16:17 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48328 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab3KDUQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:16:16 -0500
Date: Mon, 4 Nov 2013 12:16:11 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [GIT PULL] bcache changes for 3.13
Message-ID: <20131104201611.GB27733@kmo>
References: <20131104200747.GD27129@kmo>
 <5277FFA1.6060001@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5277FFA1.6060001@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 01:12:17PM -0700, Jens Axboe wrote:
> On 11/04/2013 01:07 PM, Kent Overstreet wrote:
> > Hey Jens, sorry for being late with this - anyways, it's roughly the same set of
> > patches you had queued up before plus a few minor fixes, but it's been rebased
> > onto your for-3.13/core branch.
> 
> Merge window is a little later this time, and since it was already in
> for the previous release, we can make it happen.
> 
> But can you please base it on for-3.13/drivers however? That's where I'd
> like to pull in the driver bits, and if I pull this one, then things get
> even more tangled since for-3.13/core is holding the blk-mq changes too.

I'd like to do the merge with immutable biovecs myself though - there's some
tricky bits in there. How will that work?
