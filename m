Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaBXUhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:37:51 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36147 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaBXUhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:37:50 -0500
Date: Mon, 24 Feb 2014 21:37:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jens Axboe <axboe@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Don Zickus <dzickus@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/11] smp: Single IPI cleanups v2
Message-ID: <20140224203743.GF14009@localhost.localdomain>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
 <530B7F75.1050600@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B7F75.1050600@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 09:20:53AM -0800, Jens Axboe wrote:
> On 2014-02-24 07:39, Frederic Weisbecker wrote:
> >Hi,
> >
> >This version includes:
> >
> >* Rename __smp_call_function_single to smp_call_function_single() as
> >   suggested by Christoph.
> >
> >* Acks and reviewed-by added.
> >
> >* Rebase against -rc4
> >
> >Thanks.
> 
> I'd be happy to take this in, as it's mostly centered around the blk
> cleanups.

I initially planned to push this tree to Ingo because I have some nohz patches
that will depend on this set.

But there is indeed quite some block changes there. So I should let these go
through your tree to avoid bad conflicts. If you never rebase your tree I can
work on top if it.

Thanks!
