Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaKJQiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:38:50 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53231 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaKJQit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:38:49 -0500
Message-ID: <5460EA16.1060908@kernel.dk>
Date: Mon, 10 Nov 2014 09:38:46 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
CC: drbd-dev@lists.linbit.com
Subject: Re: [PATCH 0/7] DRBD updates for the 3.19 merge window
References: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
In-Reply-To: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-10 09:21, Philipp Reisner wrote:
> Hi Jens,
>
> please take these patches for you for-3.19/drivers branch.
> They where posted for review on 2014-10-29.
>
> Some cleanups and 3 fixes. Two of them marked for stable:
> 0005-drbd-merge_bvec_fn-properly-remap-bvm-bi_bdev.patch and
> 0006-drbd-Fix-state-change-in-case-of-connection-timeout.patch
> (marked for stable)

Applied, thanks.

-- 
Jens Axboe

