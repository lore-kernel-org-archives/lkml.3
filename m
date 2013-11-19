Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab3KSV16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:27:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48377 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3KSV1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:27:55 -0500
Message-ID: <528BD7B8.4030108@oracle.com>
Date: Tue, 19 Nov 2013 14:27:20 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pravin Shelar <pshelar@nicira.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] mm: hugetlb: use get_page_foll in follow_hugetlb_page
References: <1384537668-10283-1-git-send-email-aarcange@redhat.com> <1384537668-10283-3-git-send-email-aarcange@redhat.com>
In-Reply-To: <1384537668-10283-3-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 10:47 AM, Andrea Arcangeli wrote:
> get_page_foll is more optimal and is always safe to use under the PT
> lock. More so for hugetlbfs as there's no risk of race conditions with
> split_huge_page regardless of the PT lock.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>

--
Khalid

