Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaHGNAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:00:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757511AbaHGNAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:00:50 -0400
Date: Thu, 7 Aug 2014 15:00:42 +0200
From: Karel Zak <kzak@redhat.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] brd: Request from fdisk 4k alignment
Message-ID: <20140807130042.GB9401@x2.net.home>
References: <53E21125.9080308@plexistor.com>
 <53E21317.7080403@plexistor.com>
 <1407362634.2869.2.camel@rzwisler-mobl1.amr.corp.intel.com>
 <53E36E53.3090008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E36E53.3090008@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:17:23PM +0300, Boaz Harrosh wrote:

> > Is there an error case that this patch fixes?  I've had page alignment checks
> > in my PRD direct_access code forever, and I don't know if they've ever
> > tripped.  
> > 
> 
> Yes! as I said above fix fdisk. You never tripped on it because partitions never
> worked and you never tried them. With current code fdisk is very trigger happy

 What do you mean with fdisk? which version?

 The current fdisk (and cfdisk) follows I/O limits it has no problem
 with 4K devices. All you need is to provide all necessary information 
 by /sys (or ioctls).

> to miss-align my partitions. Depending on size maybe not the very first one but the
> consecutive ones easily.

 it would be nice to have usable bug report...

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
