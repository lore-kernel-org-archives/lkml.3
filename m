Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3FNR5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:57:18 -0400
Received: from mail-gh0-f169.google.com ([209.85.160.169]:46422 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FNR5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:57:17 -0400
Date: Fri, 14 Jun 2013 10:57:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] mm/writeback: rename WB_REASON_FORKER_THREAD to
 WB_REASON_WORKER_THREAD
Message-ID: <20130614175710.GB6593@mtj.dyndns.org>
References: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371195041-26654-4-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371195041-26654-4-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 03:30:37PM +0800, Wanpeng Li wrote:
> After commit 839a8e86("writeback: replace custom worker pool implementation
> with unbound workqueue"), there is no bdi forker thread any more. This patch
> rename WB_REASON_FORKER_THREAD to WB_REASON_WORKER_THREAD since works are
> done by emergency worker.

This is somewhat userland visible and we'll be exposing exactly the
same information with just a different name.  While the string doesn't
match the current implementation exactly, I don't think we need to
change it.  Maybe add a comment there saying why it has a mismatching
name is enough?

Thanks.

-- 
tejun
