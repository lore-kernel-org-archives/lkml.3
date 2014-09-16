Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaIPVEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:04:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaIPVEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:04:02 -0400
Date: Tue, 16 Sep 2014 14:03:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/7] Define new syscalls readv2,preadv2,writev2,pwritev2
Message-ID: <20140916210359.GB24591@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <057d758976db2fcce58e394abaa0d55e48cdeec1.1410810247.git.milosz@adfin.com>
 <x491trbz81r.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491trbz81r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 03:20:32PM -0400, Jeff Moyer wrote:
> Milosz Tanski <milosz@adfin.com> writes:
> 
> > New syscalls with an extra flag argument. For now all flags except for 0 are
> > not supported.
> 
> The blatant copy-n-paste of the vectored functions bothers me.  I'll
> withold judgement until I've seen your next version of the patch series,
> though.

We could actually implement the non-flags ones based on the flagged ones
at the syscall level, similar to how recv is implemented on top of
recvfrom.

