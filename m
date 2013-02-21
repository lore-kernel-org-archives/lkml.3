Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3BUDuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 22:50:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46011 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3BUDuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 22:50:12 -0500
Date: Wed, 20 Feb 2013 19:48:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
        viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
        martin.petersen@oracle.com, Artem Bityutskiy <dedekind1@gmail.com>,
        neilb@suse.de, Adrian Hunter <adrian.hunter@intel.com>,
        david@fromorbit.com, gnehzuil.liu@gmail.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        bharrosh@panasas.com, jlayton@samba.org, linux-mtd@lists.infradead.org,
        linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
Subject: Re: [PATCH 6/6] ubifs: Wait for page writeback to provide stable
 pages
Message-ID: <20130221034834.GA4055@blackbox.djwong.org>
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
 <20130119011316.20902.56721.stgit@blackbox.djwong.org>
 <20130123134312.b69c53cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123134312.b69c53cd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 01:43:12PM -0800, Andrew Morton wrote:
> On Fri, 18 Jan 2013 17:13:16 -0800
> "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> > When stable pages are required, we have to wait if the page is just
> > going to disk and we want to modify it. Add proper callback to
> > ubifs_vm_page_mkwrite().
> > 
> > CC: Artem Bityutskiy <dedekind1@gmail.com>
> > CC: Adrian Hunter <adrian.hunter@intel.com>
> > CC: linux-mtd@lists.infradead.org
> > From: Jan Kara <jack@suse.cz>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A couple of these patches had this From:Jan strangely embedded in the
> signoff area.  I have assumed that they were indeed authored by Jan.
> 
> Please note that authorship is indicated by putting the From: line
> right at the start of the chagnelog.
> 
> 
> I grabbed the patches.  They should appear in linux-next tomorrow if I
> can get the current pooppile to build.

Well... these patches have been banging around in -next for a month or so now.
As far as I know there haven't been any complaints.  Can we push these for 3.9?

--D
