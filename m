Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3IUUBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 16:01:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53137 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3IUUBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 16:01:36 -0400
Date: Sat, 21 Sep 2013 14:01:32 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Olof Johansson <olof@lixom.net>, Jeff Moyer <jmoyer@redhat.com>,
        OS Engineering <osengineering@stec-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
Message-ID: <20130921200132.GF2312@kernel.dk>
References: <26D762E250385C4D8E9D6EC3C8E47DC11E6FCF20@sambx4.stec-inc.ad>
 <x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com>
 <26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad>
 <x4938pjbhqk.fsf@segfault.boston.devel.redhat.com>
 <5228913A.50807@kernel.dk>
 <CAOesGMhF42=qQLyMyF4-tsTjCxwX0bb10rTQv9sLooyzrEOpHA@mail.gmail.com>
 <5238B9A7.6040002@kernel.dk>
 <20130920153128.63244ec2658b7ad3aee0e2e4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920153128.63244ec2658b7ad3aee0e2e4@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20 2013, Andrew Morton wrote:
> On Tue, 17 Sep 2013 14:20:55 -0600 Jens Axboe <axboe@kernel.dk> wrote:
> 
> > > So, it looks like this driver needs a bunch of work before it's ready
> > > to go in. Or, maybe it's better to submit it with a TODO list for the
> > > staging tree instead?
> > 
> > Not disagreeing with you, it definitely needs a bit of cleaning. And so
> > far stec has not been very responsive in fixing those issues.
> 
> Geeze.  Here's what I came up with, mainly to make i386 compile:

Thanks Andrew. It's not the fixes themselves that are tricky, I would
just have liked a little more proof that the submission wasn't just a
dump'n run.

-- 
Jens Axboe

