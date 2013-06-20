Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965556Ab3FTN51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:57:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:8932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935370Ab3FTN50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,905,1363158000"; 
   d="scan'208";a="352933508"
Date: Thu, 20 Jun 2013 21:57:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Namjae Jeon <linkinjeon@gmail.com>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/6] mm/writeback: commit reason of
 WB_REASON_FORKER_THREAD mismatch name
Message-ID: <20130620135719.GB10909@localhost>
References: <1371599563-6424-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371599563-6424-3-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371599563-6424-3-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -47,6 +47,11 @@ enum wb_reason {
>  	WB_REASON_LAPTOP_TIMER,
>  	WB_REASON_FREE_MORE_MEM,
>  	WB_REASON_FS_FREE_SPACE,
> +/*
> + * There is no bdi forker thread any more and works are done by emergency
> + * worker, however, this is TPs userland visible and we'll be exposing
> + * exactly the same information, so it has a mismatch name.
> + */

Nitpick: indent the comment.

>  	WB_REASON_FORKER_THREAD,
>  
>  	WB_REASON_MAX,

Thanks,
Fengguang
