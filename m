Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaFCErZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:47:25 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40556 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaFCErY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:47:24 -0400
Message-ID: <538D5359.1080009@kernel.dk>
Date: Mon, 02 Jun 2014 22:47:21 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
CC: fengguang.wu@intel.com
Subject: Re: [PATCH] blk-mq: fix sparse warning on missed __percpu annotation
References: <1401765846-28160-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1401765846-28160-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-02 21:24, Ming Lei wrote:
> 'struct blk_mq_ctx' is  __percpu, so add the annotation
> and fix the sparse warning reported from Fengguang:
>
> 	[block:for-linus 2/3] block/blk-mq.h:75:16: sparse: incorrect
> 	type in initializer (different address spaces)

Thanks, applied.

-- 
Jens Axboe

