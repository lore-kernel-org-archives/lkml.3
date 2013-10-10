Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3JJD0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 23:26:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:15117 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab3JJD0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 23:26:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1068,1371106800"; 
   d="scan'208";a="408622137"
Date: Thu, 10 Oct 2013 11:26:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
 pointer dereference at 00000003
Message-ID: <20131010032637.GA12725@localhost>
References: <20131009073910.GA387@localhost>
 <20131010005900.GE2025@devil.localdomain>
 <20131010011640.GA5726@localhost>
 <20131010014117.GA6017@localhost>
 <20131010031515.GT4446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010031515.GT4446@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

> I note that you have CONFIG_SLUB=y, which means that the cache slabs
> are shared with objects of other types. That means that the memory
> corruption problem is likely to be caused by one of the other
> filesystems that is probing the block device(s), not XFS.

Good to know that, it would easy to test then: just turn off every
other filesystems. I'll try it right away.

Thanks,
Fengguang
