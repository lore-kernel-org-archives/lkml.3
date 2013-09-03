Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab3ICI5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:57:22 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:13027 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3ICI5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:57:20 -0400
Message-ID: <5225A3F8.5070008@huawei.com>
Date: Tue, 3 Sep 2013 16:55:20 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Joe Perches <joe@perches.com>, "'Jiri Kosina'" <trivial@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] block/ioctl.c: let code match 'kernel code style'
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <5220254E.3050704@roeck-us.net> <52203CF0.5040600@asianux.com> <52207F74.6000702@roeck-us.net> <CAFLxGvyExTMSWOppheCwDA8RorSu_mLqW9a3f3GKFrsA2xbkfA@mail.gmail.com> <52208DFD.20105@roeck-us.net> <52240566.3040201@asianux.com> <52259DDE.6070401@asianux.com>
In-Reply-To: <52259DDE.6070401@asianux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't. Pure colding style cleanup is discouraged.

You're not going to run checkpatch.pl on the whole kernel tree and fix
all the complaints, are you?

On 2013/9/3 16:29, Chen Gang wrote:
> For 'switch case', remove redundancy '\t' (also can let related lines
> within 80 columns) and remove redundancy empty lines, just like other
> 'switch case' which match 'kernel code style' within the file.
> 
> Let blkpg_ioctl() within 80 columns. Let 2nd line of blkdev_ioctl() and
> __blkdev_driver_ioctl() align 1st line parameter's start position, just
> like blk_ioctl_discard() and blk_ioctl_zeroout() within the file.
> 
> For is_unrecognized_ioctl(), can shrink the 'return' statement into one
> line (so can save 2 lines), it still matches 'kernel code style' and it
> is no conflict with others within the file.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  block/ioctl.c |  216 ++++++++++++++++++++++++++++-----------------------------
>  1 files changed, 105 insertions(+), 111 deletions(-)

