Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaDVBao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:30:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48312 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaDVBam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:30:42 -0400
Message-ID: <5355C63E.7060303@kernel.dk>
Date: Mon, 21 Apr 2014 19:30:38 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] block/blk-throttle.c: add static to blk_throtl_dispatch_work_fn
References: <20140417214116.f558fe95d1e313e7035494f1@skynet.be>
In-Reply-To: <20140417214116.f558fe95d1e313e7035494f1@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-17 13:41, Fabian Frederick wrote:
> blk_throtl_dispatch_work_fn is only used in blk-throttle.c

Thanks, applied for 3.16.

-- 
Jens Axboe

