Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162526Ab3DETB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:01:26 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:36464 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162505Ab3DETBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:01:25 -0400
Message-ID: <515F18F1.4050901@gmail.com>
Date: Fri, 05 Apr 2013 14:33:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [PATCH v3 2/3] fix hugetlb memory check in vma_dump_size()
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1365014138-19589-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1365014138-19589-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/3/13 2:35 PM), Naoya Horiguchi wrote:
> Documentation/filesystems/proc.txt says about coredump_filter bitmask,
> 
>   Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
>   effected by bit 5-6.
> 
> However current code can go into the subsequent flag checks of bit 0-4
> for vma(VM_HUGETLB). So this patch inserts 'return' and makes it work
> as written in the document.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: stable@vger.kernel.org

If I were you, I merge this patch into [1/3] because both patches treat the same
regression. but it is no big matter.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


