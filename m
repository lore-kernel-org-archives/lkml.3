Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3FQU1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:27:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44009 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3FQU1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:27:13 -0400
Date: Mon, 17 Jun 2013 13:27:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] mm/writeback: commit reason of
 WB_REASON_FORKER_THREAD mismatch name
Message-ID: <20130617202706.GM32663@mtj.dyndns.org>
References: <1371345290-19588-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371345290-19588-3-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130617083030.GE19194@dhcp22.suse.cz>
 <51bed9eb.41e9420a.2725.ffff943cSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51bed9eb.41e9420a.2725.ffff943cSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 05:41:44PM +0800, Wanpeng Li wrote:
> On Mon, Jun 17, 2013 at 10:30:30AM +0200, Michal Hocko wrote:
> >On Sun 16-06-13 09:14:46, Wanpeng Li wrote:
> >> After commit 839a8e86("writeback: replace custom worker pool implementation
> >> with unbound workqueue"), there is no bdi forker thread any more. However,
> >> WB_REASON_FORKER_THREAD is still used due to it is somewhat userland visible 
> >
> >What exactly "somewhat userland visible" means?
> >Is this about trace events?
> 
> Thanks for the question, Tejun, could you explain this for us? ;-)

Yeah, I was referring to the WB_REASON strings in
include/trace/events/writeback.h.  We can rename the internal constant
and leave the string alone too but I don't think it matters either
way.

Thanks.

-- 
tejun
