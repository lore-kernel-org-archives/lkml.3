Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbaISSCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:02:49 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65161 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbaISSCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:02:48 -0400
Message-ID: <541C6FD7.7090201@kernel.dk>
Date: Fri, 19 Sep 2014 12:03:03 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: auto-start hw queue in requeue
References: <1411136570-23439-1-git-send-email-ming.lei@canonical.com> <20140919174806.GA19983@lst.de> <541C6D7B.5000005@kernel.dk> <20140919175452.GA20333@lst.de>
In-Reply-To: <20140919175452.GA20333@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 11:54 AM, Christoph Hellwig wrote:
> On Fri, Sep 19, 2014 at 11:52:59AM -0600, Jens Axboe wrote:
>> I agree. I think Ming wanted to avoid an unnecessary bitflip if
>> possible, but the fix is more convoluted than I would like.
> 
> If the requeue from irq context ever ends up in the fast path we
> have much worse problems..

Oh yes certainly, my point was purely that I think this is why Mings fix
ended up being more involved than it need be.

-- 
Jens Axboe

