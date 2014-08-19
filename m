Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaHSCLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaHSCLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:11:10 -0400
Message-ID: <53F2B221.5070107@redhat.com>
Date: Mon, 18 Aug 2014 22:10:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        zhangyanfei@cn.fujitsu.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v15 7/7] mm: Don't split THP page when syscall is called
References: <1408321076-2231-1-git-send-email-minchan@kernel.org> <1408321076-2231-8-git-send-email-minchan@kernel.org>
In-Reply-To: <1408321076-2231-8-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2014 08:17 PM, Minchan Kim wrote:
> We don't need to split THP page when MADV_FREE syscall is
> called. It could be done when VM decide really frees it so
> we could avoid unnecessary THP split.
>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Rik van Riel <riel@redhat.com>

