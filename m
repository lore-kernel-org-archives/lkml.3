Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3GOT6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:58:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab3GOT6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:58:14 -0400
Date: Mon, 15 Jul 2013 15:58:00 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
 fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130715195800.GD1706@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20130712023930.GA6473@redhat.com>
 <20130713020030.GG3438@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713020030.GG3438@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 12:00:30PM +1000, Dave Chinner wrote:
 
 > > [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
 > ....
 > 
 > So, it's not clear what has caused this yet. Is it reproducable?

Just hit it again on the same machine.

 > would be good to get a trace of lookup vs addname events from XFS,
 > too (i.e. all the xfs_dir* and xfs_da* events) so we can see if the
 > correct lookups were done prior to the failing addname operation...
 
<- xfs tracing noob. Got a recipe I can cut-n-paste ?
Or a patch if that's necessary..

	Dave

