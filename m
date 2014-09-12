Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaILPTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:19:40 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58171 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaILPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:19:39 -0400
Message-ID: <54130F07.4010401@kernel.dk>
Date: Fri, 12 Sep 2014 09:19:35 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
CC: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canoical.com>
Subject: Re: [PATCH v2 8/9] blk-mq: handle failure path for initializing hctx
References: <1410533253-8045-1-git-send-email-ming.lei@canonical.com> <1410533253-8045-9-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1410533253-8045-9-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-12 08:47, Ming Lei wrote:
> Failure of initializing one hctx isn't handled, so this patch
> introduces blk_mq_init_hctx() and its pair to handle it explicitly.
> Also this patch makes code cleaner.

I like this, it's a good cleanup.

-- 
Jens Axboe

