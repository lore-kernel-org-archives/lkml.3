Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaFQNVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:21:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43362 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaFQNVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:21:22 -0400
Message-ID: <53A040CF.2000105@kernel.dk>
Date: Tue, 17 Jun 2014 07:21:19 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 0/3] blk-mq: bitmap tag: Fix few races
References: <cover.1402582256.git.agordeev@redhat.com> <20140617103531.GA13924@infradead.org>
In-Reply-To: <20140617103531.GA13924@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-17 04:35, Christoph Hellwig wrote:
> Jens, did you plan to pick these up?  There's a few bits of low hanging
> fruit for cleanups / micro-optimizations in this area, but I don't want
> to create conflicts with Alexanders work.

I'm evaluating just getting rid of the cyclic waits, which is why I've 
held off. But the patches don't apply to the current tree anyway, so 
they would need a rediffing no matter what.

-- 
Jens Axboe

