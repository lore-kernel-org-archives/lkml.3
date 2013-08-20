Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab3HTIco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:32:44 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14141 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3HTIcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:32:42 -0400
X-Spam-Score: -101.0
Message-ID: <52132963.1060207@asianux.com>
Date: Tue, 20 Aug 2013 16:31:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        riel@redhat.com, hughd@google.com, xemul@parallels.com,
        rientjes@google.com, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: mempolicy: the failure processing about mpol_to_str()
References: <5212E8DF.5020209@asianux.com> <20130820053036.GB18673@moon> <52130194.4030903@asianux.com> <20130820064730.GD18673@moon> <52131F48.1030002@asianux.com> <52132011.60501@asianux.com> <52132432.3050308@asianux.com> <20130820082516.GE18673@moon>
In-Reply-To: <20130820082516.GE18673@moon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 04:25 PM, Cyrill Gorcunov wrote:
> On Tue, Aug 20, 2013 at 04:09:22PM +0800, Chen Gang wrote:
>> So, for simplify thinking and implementation, use your patch below is OK
>> to me (but I suggest to print error information in the none return value
>> function).
> 
> Chen, I'm not going to dive into this area now, too busy with other stuff
> sorry, so if you consider my preliminary draft patch useful -- pick it up,
> modify it, test it and send to lkml then (just CC me).
> 
> 

OK, I will do tomorrow. :-)

Thanks.
-- 
Chen Gang
