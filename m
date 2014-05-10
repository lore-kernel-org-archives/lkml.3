Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbaEJTjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:39:24 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51702 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEJTjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:39:23 -0400
Message-ID: <536E806D.8020808@kernel.dk>
Date: Sat, 10 May 2014 13:39:25 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] blk-mq: bitmap tag: fix and cleanup
References: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2014 11:01 AM, Ming Lei wrote:
> Hi Jens and guys,
> 
> I just take a look at the new bitmap based tag allocation patches
> in -next tree, and play it for a while.
> 
> Some of them are fixes, and some of them are cleanup, please
> review.

Thanks, applied 1-4, #5 I think you are looking at an older version,
this one I already fixed yesterday.

-- 
Jens Axboe

