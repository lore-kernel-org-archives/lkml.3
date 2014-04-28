Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaD1PRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:17:46 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51774 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbaD1PRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:17:40 -0400
Message-ID: <535E7113.8000104@kernel.dk>
Date: Mon, 28 Apr 2014 09:17:39 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] random: export add_disk_randomness
References: <20140425073610.GA2143@infradead.org> <20140425073637.GB2143@infradead.org> <20140425134951.GF11124@thunk.org> <20140428112908.GB2808@infradead.org>
In-Reply-To: <20140428112908.GB2808@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 05:29 AM, Christoph Hellwig wrote:
> On Fri, Apr 25, 2014 at 09:49:51AM -0400, Theodore Ts'o wrote:
>> On Fri, Apr 25, 2014 at 12:36:37AM -0700, Christoph Hellwig wrote:
>>> This will be needed for pending changes to the scsi midlayer that now calls
>>> lower level block APIs, as well as any blk-mq driver that wants to contribute
>>> to the random pool.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Jens, can you pull this into the block tree for me?

Yep, I'll add it, thanks.

-- 
Jens Axboe

