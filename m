Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3JDVUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:20:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3JDVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:20:20 -0400
Message-ID: <524F30E2.3050304@kernel.dk>
Date: Fri, 04 Oct 2013 15:19:30 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] blk-mq fixes and improvements
References: <20131004134908.231874670@bombadil.infradead.org>
In-Reply-To: <20131004134908.231874670@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 07:49 AM, Christoph Hellwig wrote:
> The first two patches make blk-mq work fine again for me in a KVM VM,
> the others make sure that consumers don't have to care if the underlying queue
> uses blk-mq or not and remove some code at the same time.

Thanks Christoph, applied.

-- 
Jens Axboe

