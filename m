Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaIRPBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:01:03 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53256 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbaIRPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:01:00 -0400
Message-ID: <541AF3A8.3000900@kernel.dk>
Date: Thu, 18 Sep 2014 09:00:56 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
CC: drbd-dev@lists.linbit.com, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 0/2] More for the 3.18 merge window
References: <1411051782-23375-1-git-send-email-philipp.reisner@linbit.com>
In-Reply-To: <1411051782-23375-1-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-18 08:49, Philipp Reisner wrote:
> Hi Jens,
>
> please put these two patches into your for-3.18/drivers branch.  They fix
> the safety code for concurrent overlapping write detection in a DRBD
> dual primary setup.
>
> The first of those two should also go to the stable kernels, I marked it
> with CC: stable@kernel.org

Applied, thanks.

-- 
Jens Axboe

