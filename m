Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3I3JXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:23:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab3I3JX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:23:28 -0400
Date: Mon, 30 Sep 2013 11:23:27 +0200
From: Jan Kara <jack@suse.cz>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Zheng Liu <gnehzuil.liu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 062/117] ext4: fix ext4_writepages() in presence of truncate
Message-ID: <20130930092327.GA28023@quack.suse.cz>
References: <20130925001740.833541979@linuxfoundation.org>
 <20130925001747.625543023@linuxfoundation.org>
 <1380496031.14493.3.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380496031.14493.3.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 30-09-13 00:07:11, Ben Hutchings wrote:
> On Tue, 2013-09-24 at 17:18 -0700, Greg Kroah-Hartman wrote:
> > 3.11-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit 5f1132b2ba8c873f25982cf45917e8455fb6c962 upstream.
> [...]
> 
> Is this needed for any older kernel versions?
  Commit 4e7ea81db53465ddd753678bc4cebf95369d0984 (and related ones)
introduced the problem. That was merged in 3.11-rc2 so that fix needs to be
only in 3.11 and newer stable kernels.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
