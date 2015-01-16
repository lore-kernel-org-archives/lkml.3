Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbbAPNDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:03:51 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:60605 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbbAPNDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:03:49 -0500
Date: Fri, 16 Jan 2015 15:03:10 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michel Lespinasse <walken@google.com>,
        Andrew Jones <drjones@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Miller <davem@davemloft.net>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 5/5] mm: gup: kvm use get_user_pages_unlocked
Message-ID: <20150116130310.GG29085@node.dhcp.inet.fi>
References: <1421167074-9789-1-git-send-email-aarcange@redhat.com>
 <1421167074-9789-6-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421167074-9789-6-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 05:37:54PM +0100, Andrea Arcangeli wrote:
> Use the more generic get_user_pages_unlocked which has the additional
> benefit of passing FAULT_FLAG_ALLOW_RETRY at the very first page fault
> (which allows the first page fault in an unmapped area to be always
> able to block indefinitely by being allowed to release the mmap_sem).
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
-- 
 Kirill A. Shutemov
