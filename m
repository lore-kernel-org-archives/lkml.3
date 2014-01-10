Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaAJM1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:27:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:5750 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbaAJM1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:27:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,638,1384329600"; 
   d="scan'208";a="456666568"
Date: Fri, 10 Jan 2014 20:27:00 +0800
From: fengguang.wu@intel.com
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: [xfs] c91c46c12: xfstests generic/313 regression
Message-ID: <20140110122700.GA12624@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

We find this commit failed xfstests generic/313.
Attached is our kconfig.

c91c46c12768daac8486dff0f74bc52c2ec974cd is the first bad commit
commit c91c46c12768daac8486dff0f74bc52c2ec974cd
Author:     Christoph Hellwig <hch@infradead.org>
AuthorDate: Mon Nov 18 05:10:52 2013 -0800
Commit:     Ben Myers <bpm@sgi.com>
CommitDate: Fri Dec 6 17:26:19 2013 -0600

    xfs: add xfs_setattr_time
    
    Split out a xfs_setattr_time helper to share code between truncate and
    regular setattr similar to xfs_setattr_mode.  I might also have another
    caller growing for this in the near future.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

 fs/xfs/xfs_iops.c | 66 +++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

Thanks,
Fengguang
