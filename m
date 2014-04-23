Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaDWQJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:09:13 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:59192 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaDWQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:09:11 -0400
Message-ID: <5357E5A2.8060401@kernel.dk>
Date: Wed, 23 Apr 2014 10:09:06 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] blk-mq: fix leak of set->tags
References: <1398269254-14727-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1398269254-14727-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 10:07 AM, Ming Lei wrote:
> set->tags should be freed in blk_mq_free_tag_set().

Thanks, applied.

-- 
Jens Axboe

