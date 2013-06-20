Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581Ab3FTNqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:46:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:19915 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461Ab3FTNqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:46:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,905,1363158000"; 
   d="scan'208";a="352927959"
Date: Thu, 20 Jun 2013 21:46:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Namjae Jeon <linkinjeon@gmail.com>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] mm/writeback: Don't check force_wait to handle
 bdi->work_list
Message-ID: <20130620134615.GA10909@localhost>
References: <1371599563-6424-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371599563-6424-2-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371599563-6424-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  fs/fs-writeback.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)

The header file should be changed, too. Otherwise looks fine to me.

include/linux/writeback.h:97:long wb_do_writeback(struct bdi_writeback *wb, int force_wait);

Thanks,
Fengguang
