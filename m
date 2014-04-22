Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaDVBDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:03:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56820 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaDVBDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:03:12 -0400
Message-ID: <5355BFCC.2000909@kernel.dk>
Date: Mon, 21 Apr 2014 19:03:08 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v1 next 0/4] blk-mq: misc changes
References: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-19 04:00, Ming Lei wrote:
> Hi,
>
> Three of them are fixes, another one is cleanup.
>
> V1:
> 	- line break(2/4)
> 	- use explicit cast(3/4)

I believe this is v2, but I guess your first posting was v0 :-)
Applied for testing for 3.16, thanks.

-- 
Jens Axboe

