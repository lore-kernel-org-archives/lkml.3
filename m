Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaJBPx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:53:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbaJBPxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:53:54 -0400
Message-ID: <542D7479.7000504@redhat.com>
Date: Thu, 02 Oct 2014 11:51:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] mm: mempolicy: Skip inaccessible VMAs when setting
 MPOL_MF_LAZY
References: <1412256558-9995-1-git-send-email-mgorman@suse.de> <1412256558-9995-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1412256558-9995-4-git-send-email-mgorman@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 09:29 AM, Mel Gorman wrote:
> PROT_NUMA VMAs are skipped to avoid problems distinguishing between
> present, prot_none and special entries. MPOL_MF_LAZY is not visible from
> userspace since commit a720094ded8c ("mm: mempolicy: Hide MPOL_NOOP and
> MPOL_MF_LAZY from userspace for now") but it should still skip VMAs the
> same way task_numa_work does.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

