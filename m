Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3D2BkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 21:40:08 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51036 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878Ab3D2BkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 21:40:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMQAKnOfVF5LIKM/2dsb2JhbABSgwc2gk62WoUaBAF+F3SCHwEBBTocIxAIAw4KCSUPBSUDIROIFQ28TRWNVROBHQeDTwOXHZErgyMqgS8
Date: Mon, 29 Apr 2013 11:40:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20130429014002.GY10481@dastard>
References: <20130429112943.afdd088c7bb8d80046bdfd2f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429112943.afdd088c7bb8d80046bdfd2f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:29:43AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the xfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: "xfs_dquot_buf_ops" [fs/xfs/xfs.ko] undefined!
> 
> Probably caused by commit 3fe58f30b4fc ("xfs: add CRC checks for quota
> blocks").
> 
> I have used the xfs tree from next-20130426 for today.

CONFIG_XFS_QUOTA=y will fix it.

Or, alternatively, apply this patch:

http://oss.sgi.com/pipermail/xfs/2013-April/025434.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
