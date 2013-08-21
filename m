Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3HUFtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:49:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13815 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3HUFt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:49:28 -0400
X-Spam-Score: -107.0
Message-ID: <521454A6.1000306@asianux.com>
Date: Wed, 21 Aug 2013 13:48:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Chen Gang <gang.chen@asianux.com>, Mel Gorman <mgorman@suse.de>,
        kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, hughd@google.com,
        xemul@parallels.com, rientjes@google.com,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: shmem: check the return value of mpol_to_str()
References: <5212E8DF.5020209@asianux.com> <20130820053036.GB18673@moon> <52130194.4030903@asianux.com> <20130820064730.GD18673@moon> <52131F48.1030002@asianux.com> <52132011.60501@asianux.com> <52132432.3050308@asianux.com> <20130820082516.GE18673@moon> <52142422.9050209@asianux.com> <20130821053142.GQ18673@moon>
In-Reply-To: <20130821053142.GQ18673@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 01:31 PM, Cyrill Gorcunov wrote:
> On Wed, Aug 21, 2013 at 10:21:22AM +0800, Chen Gang wrote:
>> mpol_to_str() may fail, and not fill the buffer (e.g. -EINVAL), so need
>> check about it, or buffer may not be zero based, and next seq_printf()
>> will cause issue.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Looks good to me, thanks!
> 
> Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
> 

Thanks.

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 


-- 
Chen Gang
