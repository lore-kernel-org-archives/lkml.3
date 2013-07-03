Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3GCQB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:01:58 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60426 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3GCQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:01:57 -0400
Message-ID: <51D44AE7.1090701@gmail.com>
Date: Thu, 04 Jul 2013 00:01:43 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [RFC PATCH 0/5] Support multiple pages allocation
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com> <20130703152824.GB30267@dhcp22.suse.cz> <51D44890.4080003@gmail.com>
In-Reply-To: <51D44890.4080003@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 11:51 PM, Zhang Yanfei wrote:
> On 07/03/2013 11:28 PM, Michal Hocko wrote:
>> On Wed 03-07-13 17:34:15, Joonsoo Kim wrote:
>> [...]
>>> For one page allocation at once, this patchset makes allocator slower than
>>> before (-5%). 
>>
>> Slowing down the most used path is a no-go. Where does this slow down
>> come from?
> 
> I guess, it might be: for one page allocation at once, comparing to the original
> code, this patch adds two parameters nr_pages and pages and will do extra checks
> for the parameter nr_pages in the allocation path.
> 

If so, adding a separate path for the multiple allocations seems better.

>>
>> [...]
> 
> 


-- 
Thanks.
Zhang Yanfei
