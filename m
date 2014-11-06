Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaKFB3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:29:24 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:1599 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750873AbaKFB3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:29:22 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="42929704"
Message-ID: <545ACB73.3050402@cn.fujitsu.com>
Date: Thu, 6 Nov 2014 09:14:27 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Benjamin LaHaise <bcrl@kvack.org>, <linux-aio@kvack.org>,
        <m.koenigshaus@wut.de>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] aio: fix uncorrent dirty pages accouting when truncating
 AIO ring buffer
References: <1414750042-20832-1-git-send-email-guz.fnst@cn.fujitsu.com> <5459F387.909@cn.fujitsu.com> <20141105145620.GA23695@kvack.org> <20141105130018.7750139c497f842bdf6070e4@linux-foundation.org>
In-Reply-To: <20141105130018.7750139c497f842bdf6070e4@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
On 11/06/2014 05:00 AM, Andrew Morton wrote:

> On Wed, 5 Nov 2014 09:56:20 -0500 Benjamin LaHaise <bcrl@kvack.org> wrote:
> 
>> On Wed, Nov 05, 2014 at 05:53:11PM +0800, Gu Zheng wrote:
>>> ping...
>>
>> I need someone a bit more familiar with this area of code to chime in on 
>> reviewing this.  Andrew, can you provide any feedback on this fix?
> 
> That looks like a sensible solution and the changelog is good.  A
> couple of suggested modifications:
> 
> - Don't use the term "pinned" in the changelog without explaining it
>   - it's a terribly ambiguous term.  I assume here you mean "pinned by
>   elevating the page's refcount"?

Yes.

> 
> - Could we have just one wee little code comment, explaining why
>   aio_fs_backing_dev_info exists, what function it is serving?  Put
>   yourself in the position of a reader wondering "why is this here".
> .

Got it.
Thanks for your suggestion. Will update it soon.

Regards,
Gu

> 


