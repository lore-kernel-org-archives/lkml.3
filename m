Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbbAYK3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 05:29:36 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36392 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbAYK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 05:29:32 -0500
Message-ID: <54C4C577.6000002@gmail.com>
Date: Sun, 25 Jan 2015 18:29:11 +0800
From: Ming Lei <tom.leiming@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Dongsu Park <dongsu.park@profitbricks.com>
CC: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: Re: cleanup and refactor BLOCK_PC mapping helpers V2
References: <1421594194-25918-1-git-send-email-hch@lst.de>
In-Reply-To: <1421594194-25918-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/18/2015 11:16 PM, Christoph Hellwig wrote:
> This series is based on the first two patches from the reent
> series that Dongsu Park recently sent, and refactors and cleanups
> up various aspect of our BLOCK_PC mapping helpers.
>
> Changes since V1:
>   - keep a separate blk_rq_map_user for now, it contains magic
>     for the sg and tape drivers that's still missing from
>     blk_rq_map_user_iov

Looks all are nice cleanup:

Reviewed-by: Ming Lei <tom.leiming@gmail.com>

Also patches passed xfstests(check -g auto) against v3.19-rc4_next-20150115.

Thanks,
Ming Lei
