Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab3BUWcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:32:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab3BUWcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:32:45 -0500
Date: Thu, 21 Feb 2013 14:32:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
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
Message-Id: <20130221143243.099bef3c.akpm@linux-foundation.org>
In-Reply-To: <20130221034834.GA4055@blackbox.djwong.org>
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
	<20130119011316.20902.56721.stgit@blackbox.djwong.org>
	<20130123134312.b69c53cd.akpm@linux-foundation.org>
	<20130221034834.GA4055@blackbox.djwong.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 19:48:34 -0800
"Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> > I grabbed the patches.  They should appear in linux-next tomorrow if I
> > can get the current pooppile to build.
> 
> Well... these patches have been banging around in -next for a month or so now.
> As far as I know there haven't been any complaints.  Can we push these for 3.9?

yup.  You can normally assume that this is the case, unless the patches have

a) been causing bugs or

b) been getting rude review comments or

c) been getting a great string of fix-fix-fix-fix patches in -mm or

d) acquired rude akpm comments or unresolved questions against them
   in http://ozlabs.org/~akpm/mmots/series
