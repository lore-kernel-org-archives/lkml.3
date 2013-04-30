Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3D3Sgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:36:55 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39815 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761358Ab3D3Sgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:36:49 -0400
Date: Tue, 30 Apr 2013 13:36:47 -0500
From: Ben Myers <bpm@sgi.com>
To: Dave Chinner <david@fromorbit.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: xfs@oss.sgi.com, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20130430183647.GF812@sgi.com>
References: <20130429112943.afdd088c7bb8d80046bdfd2f@canb.auug.org.au>
 <20130429014002.GY10481@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429014002.GY10481@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen and Dave,

On Mon, Apr 29, 2013 at 11:40:02AM +1000, Dave Chinner wrote:
> On Mon, Apr 29, 2013 at 11:29:43AM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the xfs tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > ERROR: "xfs_dquot_buf_ops" [fs/xfs/xfs.ko] undefined!
> > 
> > Probably caused by commit 3fe58f30b4fc ("xfs: add CRC checks for quota
> > blocks").
> > 
> > I have used the xfs tree from next-20130426 for today.
> 
> CONFIG_XFS_QUOTA=y will fix it.
> 
> Or, alternatively, apply this patch:
> 
> http://oss.sgi.com/pipermail/xfs/2013-April/025434.html

I applied this patch so it should be fixed today.

Regards,
	Ben
