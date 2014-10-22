Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaJVN7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:59:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42614 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJVN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:59:40 -0400
Message-ID: <5447B84B.3040707@kernel.dk>
Date: Wed, 22 Oct 2014 07:59:39 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: hch@lst.de, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] null_blk: Cleanup error recovery in null_add_dev()
References: <1413984861-8260-1-git-send-email-jack@suse.cz>
In-Reply-To: <1413984861-8260-1-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 07:34 AM, Jan Kara wrote:
> When creation of queues fails in init_driver_queues(), we free the
> queues. But null_add_dev() doesn't test for this failure and continues
> with the setup leading to strange consequences, likely oops. Fix the
> problem by testing whether init_driver_queues() failed and do proper
> error cleanup.

Thanks Jan, applied.

-- 
Jens Axboe

