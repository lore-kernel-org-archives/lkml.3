Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaHFL6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:58:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaHFL6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
Date: Wed, 6 Aug 2014 19:58:49 +0800
Message-ID: <CACVXFVPHHULvp=hK0D3qiE_M-28GS338fnbOH-iFCLBV2uE-Dg@mail.gmail.com>
Subject: Re: [PATCH 0/9] block/aio: loop mq conversion and kernel aio
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Ping

Thanks,

On Thu, Jul 24, 2014 at 6:55 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Hi,
>
> The first 6 patches convert current loop driver into blk-mq, and
> loop's scalability can get improved a lot.
>
> The 7th and 8th patches introduce kernel AIO support, most of
> is borrow from Dave's work last year, and thanks to ITER_BVEC,
> now it is easier to implement kernel AIO now.
>
> The 9th patch uses kernel AIO with O_DIRECT to improve loop's
> performance in single thread.
>
> With blk-mq and kernel AIO, both scalability and performance
> of loop driver get lot of improvement.
>
> Thanks,
>
