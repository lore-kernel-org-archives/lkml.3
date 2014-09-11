Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaIKPMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:12:18 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60293 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaIKPMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:12:17 -0400
Message-ID: <5411BBCA.5070905@kernel.dk>
Date: Thu, 11 Sep 2014 09:12:10 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
CC: drbd-dev@lists.linbit.com
Subject: Re: [PATCH 0/9] DRBD updates for 3.18
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-11 06:29, Philipp Reisner wrote:
> Hi Jens,
>
> please consider to put these patches into your (future) for-3.18/drivers
> branch. I have posted it for review on August 28. It consists mainly of
> minor cleanups, and an important performance improvement. With that
> DRBD was seen to write with 160k IOPS, on SSDs.

Applied, thanks Philipp.

-- 
Jens Axboe

