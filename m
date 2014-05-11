Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaEKRkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 13:40:15 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34710 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaEKRkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 13:40:10 -0400
Message-ID: <536FB5FC.6000305@kernel.dk>
Date: Sun, 11 May 2014 11:40:12 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140509120733.GA27918@kernel.org> <20140509150018.GA26215@infradead.org> <20140510040023.GA13788@kernel.org>
In-Reply-To: <20140510040023.GA13788@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 10:00 PM, Shaohua Li wrote:
> On Fri, May 09, 2014 at 08:00:18AM -0700, Christoph Hellwig wrote:
>> On Fri, May 09, 2014 at 08:07:33PM +0800, Shaohua Li wrote:
>>>
>>> flush request is special, which borrows tag from other request. Need a special
>>> handling to get it from tag.
>>
>> Thanks, we probably need this one.  But I think you can simply test
>> REQ_FLUSH_SEQ the passed in request instead of the flush_rq_tag_valid
>> flag/
> 
> fair enough. updated one.
> 
>  
> Subject: blk-mq: blk_mq_tag_to_rq should handle flush request
> 
> flush request is special, which borrows tag from other request. Need a special
> handling to get it from tag.

This looks good, applied, thanks!

-- 
Jens Axboe

