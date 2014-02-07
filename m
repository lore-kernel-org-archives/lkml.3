Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaBGTa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:30:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaBGTa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:30:58 -0500
Message-ID: <52F53425.7060308@redhat.com>
Date: Fri, 07 Feb 2014 14:29:41 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] drop_caches: add some documentation and info message
References: <1391794851-11412-1-git-send-email-hannes@cmpxchg.org> <52F51E19.9000406@redhat.com> <20140207181332.GG6963@cmpxchg.org>
In-Reply-To: <20140207181332.GG6963@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 01:13 PM, Johannes Weiner wrote:

>> Would it be better to print this after the operation
>> has completed?
>
> It would make more sense grammatically :-) Either way is fine with me,
> updated below to inform after the fact.

Well, in principle the operation could take an arbitrarily
long time, so there are some minor concerns besides
grammatical correctness, too :)

Thanks for updating the patch.

> ---
> From: Dave Hansen <dave@linux.vnet.ibm.com>
> Date: Fri, 12 Oct 2012 14:30:54 +0200
> Subject: [patch] drop_caches: add some documentation and info message

> Dropping caches is a very drastic and disruptive operation that is
> good for debugging and running tests, but if it creates bug reports
> from production use, kernel developers should be aware of its use.
>
> Add a bit more documentation about it, and add a little KERN_NOTICE.
>
> [akpm@linux-foundation.org: checkpatch fixes]
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

