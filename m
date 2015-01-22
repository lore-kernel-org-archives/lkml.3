Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbbAVPW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:22:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbbAVPW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:22:27 -0500
Message-ID: <54C115AC.9030606@suse.cz>
Date: Thu, 22 Jan 2015 16:22:20 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/5] mm, compaction: encapsulate resetting cached scanner
 positions
References: <1421661920-4114-1-git-send-email-vbabka@suse.cz> <1421661920-4114-4-git-send-email-vbabka@suse.cz> <54BE5885.7030506@gmail.com>
In-Reply-To: <54BE5885.7030506@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 02:30 PM, Zhang Yanfei wrote:
> 在 2015/1/19 18:05, Vlastimil Babka 写道:
>> Reseting the cached compaction scanner positions is now done implicitly in
>> __reset_isolation_suitable() and compact_finished(). Encapsulate the
>> functionality in a new function reset_cached_positions() and call it
>> explicitly where needed.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Thanks.

> Should the new function be inline?

I'll try comparing with bloat-o-meter before next submission, if there's 
any difference.

> Thanks.
>

