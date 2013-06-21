Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422798Ab3FUAdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:33:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:11647 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161331Ab3FUAdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,908,1363158000"; 
   d="scan'208";a="353262086"
Date: Fri, 21 Jun 2013 08:33:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Namjae Jeon <linkinjeon@gmail.com>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/6] mm/writeback: Don't check force_wait to handle
 bdi->work_list
Message-ID: <20130621003330.GD11033@localhost>
References: <1371774534-4139-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371774534-4139-2-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371774534-4139-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Andrew: this patch must be ordered _after_ "fs/fs-writeback.c: make
wb_do_writeback() as static" to avoid build errors.

Thanks,
Fengguang
