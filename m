Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaEIBJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:09:53 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20103 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756013AbaEIBJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:09:51 -0400
X-IronPort-AV: E=Sophos;i="4.97,1014,1389715200"; 
   d="scan'208";a="30282836"
Message-ID: <536C1CD8.2030602@cn.fujitsu.com>
Date: Fri, 9 May 2014 09:10:00 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dongsheng Yang <dongsheng081251@gmail.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] treewide: remove all open implementation of nice_to_rlimit()/rlimit_to_nice().
References: <e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com> <a568a1e3cc8e78648f41b5035fa5e381d36274da.1399532322.git.yangds.fnst@cn.fujitsu.com> <20140508143404.GV11096@twins.programming.kicks-ass.net> <CA+qeAOqCo9g=tNARWf4JESLZU6sAoSKYDvmfGE6OOmJQhajyDw@mail.gmail.com> <20140508152614.GC30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140508152614.GC30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 12:26 AM, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 10:51:13PM +0800, Dongsheng Yang wrote:
>> Just want to avoid using hardcoding of 20. If no, there is no meaning we
>> collect
>> priority related information into prio.h.  And convertion between nice
>> value [-20,19]
>> and rlimit style value [0,40] is used by several callers currently.
>>
> Yeah, not really a comment on your patch, just a general observation on
> the thing you touched :-)

Ha, okey, thanx for your reply. :)
