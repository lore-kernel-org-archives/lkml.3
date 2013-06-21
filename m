Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab3FUAhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:37:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:58876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab3FUAht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:37:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,908,1363158000"; 
   d="scan'208";a="353263152"
Date: Fri, 21 Jun 2013 08:37:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Namjae Jeon <linkinjeon@gmail.com>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/6] mm/writeback: remove wb_reason_name
Message-ID: <20130621003743.GE11033@localhost>
References: <1371774534-4139-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371774534-4139-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 08:28:49AM +0800, Wanpeng Li wrote:
> wb_reason_name is not used any more, this patch remove it.
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

