Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3EXK64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:58:56 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:24885 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab3EXK6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:58:55 -0400
Date: Fri, 24 May 2013 12:58:52 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Karel Zak <kzak@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130524105852.GA26617@frolo.macqel>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be> <1367270313-18871-3-git-send-email-phdm@macqel.be> <20130520163927.8e4c2fe753b60a02c368ceb5@linux-foundation.org> <20130521072754.GB19266@frolo.macqel> <20130524100452.GA15570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524100452.GA15570@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 06:04:52AM -0400, Christoph Hellwig wrote:
> On Tue, May 21, 2013 at 09:27:54AM +0200, Philippe De Muyter wrote:
> > AIX LVM permits to make "logical volumes" which are made of multiple slices
> > of multiple disks.  The new code allows only access to the "logical volumes"
> > which are made of one slice on the probed disk, a slice being a contiguous
> > disk area.  The code also detects "logical volumes" made of multiple slices
> > on the probed disk, but can not describe them to the partition layer, because
> > the partition layer generic code does not support that.  When such
> > non-contiguous "logical volumes" are detected, a diagnostic message is
> > printed.
> 
> This very much screams like it should be implemented in the lvm2
> userspace package using the dm kernel driver.

Is lvm2 a generic tool for discovering foreign partition layouts, or it is
about one linux-specific lvm implementation ?

Philippe
