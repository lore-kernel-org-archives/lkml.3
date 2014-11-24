Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaKXPED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:04:03 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55013 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaKXPEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:04:01 -0500
Message-ID: <547348DE.60704@kernel.dk>
Date: Mon, 24 Nov 2014 08:03:58 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: kmo@daterainc.com, akpm@linux-foundation.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        drbd-user@lists.linbit.com
Subject: Re: [PATCH 0/6] blk: introduce generic io stat accounting help function
References: <1416798327-12817-1-git-send-email-guz.fnst@cn.fujitsu.com>
In-Reply-To: <1416798327-12817-1-git-send-email-guz.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2014 08:05 PM, Gu Zheng wrote:
> Many block drivers accounting io stat based on bio (e.g. NVMe...),
> the blk_account_io_start/end() which is based on request
> does not make sense to them, so here we introduce the similar help
> function named generic_start/end_io_acct base on raw sectors, and it can
> simplify some driver's open io accounting code.
>
> Gu Zheng (6):
>    blk: introduce generic io stat accounting help function
>    NVMe: use generic io stat accounting functions to simplify
>      nvme_start/end_io_acct
>    md/bcache: use generic io stats accounting functions to simplify io
>      stat accounting
>    drbd: use generic io stats accounting functions to simplify io stat
>      accounting
>    md: use generic io stats accounting functions to simplify io stat
>      accounting
>    block/rsxx: use generic io stats accounting functions to simplify io
>      stat accounting

Thanks, this looks good. I'll apply it, except 2/6, since nvme no longer 
uses them.

-- 
Jens Axboe

