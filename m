Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763221Ab3DCTW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762237Ab3DCTW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:22:27 -0400
Message-ID: <515C80EB.8070801@redhat.com>
Date: Wed, 03 Apr 2013 15:20:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] hugetlbfs: stop setting VM_DONTDUMP in initializing
 vma(VM_HUGETLB)
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1365014138-19589-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1365014138-19589-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 02:35 PM, Naoya Horiguchi wrote:
> Currently we fail to include any data on hugepages into coredump,
> because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
> introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
> mm->reserved_vm counter". This looks to me a serious regression,
> so let's fix it.
>
> ChangeLog v3:
>   - move 'return 0' into a separate patch
>
> ChangeLog v2:
>   - add 'return 0' in hugepage memory check
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Cc: stable@vger.kernel.org

Reviewed-by: Rik van Riel <riel@redhat.com>

