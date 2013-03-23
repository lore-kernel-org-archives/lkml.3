Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3CWP4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 11:56:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3CWP4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 11:56:23 -0400
Message-ID: <514DD065.3000106@redhat.com>
Date: Sat, 23 Mar 2013 11:55:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] migrate: add migrate_entry_wait_huge()
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363983835-20184-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 04:23 PM, Naoya Horiguchi wrote:
> When we have a page fault for the address which is backed by a hugepage
> under migration, the kernel can't wait correctly until the migration
> finishes. This is because pte_offset_map_lock() can't get a correct
> migration entry for hugepage. This patch adds migration_entry_wait_huge()
> to separate code path between normal pages and hugepages.
>
> ChangeLog v2:
>   - remove dup in migrate_entry_wait_huge()
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
