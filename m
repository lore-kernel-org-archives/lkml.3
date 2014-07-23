Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaGWEKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:10:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:44123 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754537AbaGWEKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:10:14 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33663912"
Message-ID: <53CF32CA.3030008@cn.fujitsu.com>
Date: Wed, 23 Jul 2014 11:58:02 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: <axboe@kernel.dk>, <akpm@linux-foundation.org>, <linux-aio@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] aio: fix some comments
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com> <1405996804-8262-3-git-send-email-guz.fnst@cn.fujitsu.com> <20140722141220.GD26030@kvack.org>
In-Reply-To: <20140722141220.GD26030@kvack.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 10:12 PM, Benjamin LaHaise wrote:

> On Tue, Jul 22, 2014 at 10:40:03AM +0800, Gu Zheng wrote:
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> Again, you're missing a commit message here.  Please resubmit with a commit 
> message.

Got it, I'll resend it later.

Thanks,
Gu

> 
> 		-ben
> 
>> ---
>>  fs/aio.c |    7 +++----
>>  1 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 1dc6158..0cd0479 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -1037,7 +1037,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
>>  }
>>  EXPORT_SYMBOL(aio_complete);
>>  
>> -/* aio_read_events
>> +/* aio_read_events_ring
>>   *	Pull an event off of the ioctx's event ring.  Returns the number of
>>   *	events fetched
>>   */
>> @@ -1289,9 +1289,8 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb,
>>  }
>>  
>>  /*
>> - * aio_setup_iocb:
>> - *	Performs the initial checks and aio retry method
>> - *	setup for the kiocb at the time of io submission.
>> + * aio_run_iocb:
>> + *	Performs the initial checks and io submission.
>>   */
>>  static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
>>  			    char __user *buf, bool compat)
>> -- 
>> 1.7.7
> 


