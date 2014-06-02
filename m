Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaFBKcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:32:07 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:42729 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaFBKcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:32:06 -0400
Message-ID: <538C529F.1080707@bjorling.me>
Date: Mon, 02 Jun 2014 12:31:59 +0200
From: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] basic conversion to blk-mq
References: <1401400285-25003-1-git-send-email-m@bjorling.me> <20140602094251.GA30612@infradead.org>
In-Reply-To: <20140602094251.GA30612@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 11:42 AM, Christoph Hellwig wrote:
> On Thu, May 29, 2014 at 11:51:24PM +0200, Matias Bj??rling wrote:
>> Hi Matthew and Keith,
>>
>> Thanks for the quick review.
>>
>> The patch has been updated with the feedback from Keith and Jens. It's against
>> Jens' 3.16/core tree. You may use the nvmemq_wip_review branch at:
>>
>> https://github.com/MatiasBjorling/linux-collab nvmemq_wip_review
>
> It seems like this includes more patches than the one you're sending
> out, care to send the full series next time?
>

Yes. The nvmemq_wip_review currently holds the in-progress v5 patch. I 
make sure to split it out for the next serie and onward.

