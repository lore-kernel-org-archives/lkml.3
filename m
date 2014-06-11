Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaFKVeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:34:06 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46103 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaFKVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:34:03 -0400
Message-ID: <5398CB47.8050607@kernel.dk>
Date: Wed, 11 Jun 2014 15:33:59 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove elv_abort_queue and blk_abort_flushes
References: <20140611114923.GA21981@lst.de>
In-Reply-To: <20140611114923.GA21981@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 05:49 AM, Christoph Hellwig wrote:
> elv_abort_queue has no callers, and blk_abort_flushes is only called by
> elv_abort_queue.

Applied, thanks.

-- 
Jens Axboe

