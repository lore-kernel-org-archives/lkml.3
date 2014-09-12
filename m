Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaILPSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:18:52 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47927 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaILPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:18:51 -0400
Message-ID: <54130ED7.4080106@kernel.dk>
Date: Fri, 12 Sep 2014 09:18:47 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/9] block: introduce blk_init_flush and its pair
References: <1410533253-8045-1-git-send-email-ming.lei@canonical.com> <1410533253-8045-3-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1410533253-8045-3-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-12 08:47, Ming Lei wrote:
> These two functions are introduced to initialize and de-initialize
> flush stuff centrally.

I know you said these change later to more proper naming, but that only 
happens further down. Lets get rid of these wrappers and just call 
blk_alloc_flush_queue() directly.

-- 
Jens Axboe

