Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbaJaTNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:13:16 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:41031 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaJaTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:13:15 -0400
Date: Fri, 31 Oct 2014 12:13:12 -0700
From: Peter Feiner <pfeiner@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michel Lespinasse <walken@google.com>,
        Andrew Jones <drjones@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Miller <davem@davemloft.net>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 3/5] mm: gup: use get_user_pages_unlocked within
 get_user_pages_fast
Message-ID: <20141031191312.GB38315@google.com>
References: <1414600520-7664-1-git-send-email-aarcange@redhat.com>
 <1414600520-7664-4-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414600520-7664-4-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:35:18PM +0100, Andrea Arcangeli wrote:
> This allows the get_user_pages_fast slow path to release the mmap_sem
> before blocking.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Peter Feiner <pfeiner@google.com>
