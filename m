Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaIBQYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:24:23 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50629 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaIBQYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:24:22 -0400
Message-ID: <5405EF38.60007@kernel.dk>
Date: Tue, 02 Sep 2014 10:24:24 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@canonical.com>
CC: linux-kernel@vger.kernel.org, Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com> <20140902162146.GA28741@infradead.org>
In-Reply-To: <20140902162146.GA28741@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 10:21 AM, Christoph Hellwig wrote:
> Btw, one thing we should reconsider is where we set
> QUEUE_FLAG_NO_SG_MERGE.  At least for virtio-blk it seems to me that
> doing the S/G merge should be a lot cheaper than fanning out into the
> indirect descriptors.

And we might consider flipping the default, as most would probably like
to have the sg merging on.

-- 
Jens Axboe

