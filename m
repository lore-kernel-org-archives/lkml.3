Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaGJULZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:11:25 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34960 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaGJULX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:11:23 -0400
Message-ID: <53BEF367.6060703@kernel.dk>
Date: Thu, 10 Jul 2014 22:11:19 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
CC: drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] DRBD updates for your for-3.17/drivers branch
References: <14195494.KgRksUidBS@fat-tyre> <1620384.qJGGe2kQsK@fat-tyre>
In-Reply-To: <1620384.qJGGe2kQsK@fat-tyre>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-10 18:47, Philipp Reisner wrote:
> Hi Jens,
>
> shame on me. The previous pull request had a mistake in commit
> 7 'drbd: get rid of atomic update on disk bitmap works'.
> It missed the function drbd_bm_write_lazy() in drbd_bitmap.c.
> My test procedure only had a module build, but that does not
> unveil a completely missed function.
>
> Here is a branch with that mistake corrected.
>
> The following changes since commit 6a27b656fc0210e976db362e1368c56db05c8f08:
>
>    block: virtio-blk: support multi virt queues per virtio-blk device (2014-07-01 10:51:03 -0600)
>
> are available in the git repository at:
>
>    git://git.linbit.com/linux-drbd.git for-3.17v2
>
> for you to fetch changes up to bf0d6e4a1138e71cafdbbb99cde430eee50c4ff1:
>
>    drbd: silence underflow warning in read_in_block() (2014-07-10 18:35:23 +0200)

Pulled your updated variant, thanks.

-- 
Jens Axboe

