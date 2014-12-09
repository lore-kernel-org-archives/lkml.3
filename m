Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbaLIQKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:10:15 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47646 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaLIQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:10:13 -0500
Message-ID: <54871EE2.3070502@kernel.dk>
Date: Tue, 09 Dec 2014 09:10:10 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] blk-mq: Avoid that I/O hangs in bt_get()
References: <54871BD0.8020305@acm.org> <54871C41.5040500@acm.org>
In-Reply-To: <54871C41.5040500@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:58 AM, Bart Van Assche wrote:
> Avoid that if there are fewer hardware queues than CPU threads that
> bt_get() can hang. The symptoms of the hang were as follows:
> * All tags allocated for a particular hardware queue.
> * (nr_tags) pending commands for that hardware queue.
> * No pending commands for the software queues associated with that
>    hardware queue.

I already queued up the previous one, and added the extra tag get myself.

-- 
Jens Axboe

