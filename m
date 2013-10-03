Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3JCQWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:22:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51170 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3JCQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:22:11 -0400
Message-ID: <524D9984.1010909@kernel.dk>
Date: Thu, 03 Oct 2013 10:21:24 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shli@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: fix irq restore in __percpu_counter_add
References: <20131003101518.GA16562@infradead.org>
In-Reply-To: <20131003101518.GA16562@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 04:15 AM, Christoph Hellwig wrote:
> The current version of "percpu_counter: make APIs irq safe" in the blk-mq
> tree doesn't properly restore irqs, thus causing the boot of the blk-multique
> tree to fail with various irqs_disabled() BUGs and related issues.
>      
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks Christoph, merge issue I'm assuming. I'll fix it up.


-- 
Jens Axboe

