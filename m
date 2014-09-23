Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaIWGP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:15:56 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:35475 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaIWGPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:15:55 -0400
Date: Tue, 23 Sep 2014 02:15:52 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923061552.GJ11740@mtj.dyndns.org>
References: <20140923140633.35efbe7a@notabene.brown>
 <20140923041817.GA11740@mtj.dyndns.org>
 <20140923144650.2aa71b39@notabene.brown>
 <20140923045549.GB11740@mtj.dyndns.org>
 <20140923154058.6a1c2449@notabene.brown>
 <20140923055156.GC11740@mtj.dyndns.org>
 <20140923161144.65b26224@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923161144.65b26224@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

On Tue, Sep 23, 2014 at 04:11:44PM +1000, NeilBrown wrote:
> You didn't say if you preferred a flag or a 'max_size'.

Sorry, missed that.  No strong preference but a flag should be easier
and enough for now, right?

Thanks.

-- 
tejun
