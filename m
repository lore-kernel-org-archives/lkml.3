Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaACREO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:04:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51284 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaACREN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:04:13 -0500
Message-ID: <52C6ED61.8010405@kernel.dk>
Date: Fri, 03 Jan 2014 10:03:29 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: blk-mq: fix initializing request's start time
References: <1388748544-14156-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1388748544-14156-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 04:29 AM, Ming Lei wrote:
> blk_rq_init() is called in req's complete handler to initialize
> the request, so the members of start_time and start_time_ns might
> become inaccurate when it is allocated in future.
> 
> The patch initializes the two members in blk_mq_rq_ctx_init() to
> fix the problem.

Thanks, applied!

-- 
Jens Axboe

