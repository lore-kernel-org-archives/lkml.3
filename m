Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaE1WTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:19:35 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:62040 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaE1WTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:19:33 -0400
Date: Wed, 28 May 2014 18:19:29 -0400
From: Tejun Heo <tj@kernel.org>
To: paolo <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC RESEND 01/14] block: kconfig update and build bits
 for BFQ
Message-ID: <20140528221929.GG1419@htj.dyndns.org>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
 <1401194558-5283-2-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401194558-5283-2-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:42:25PM +0200, paolo wrote:
> diff --git a/block/Makefile b/block/Makefile
> index 20645e8..cbd83fb 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_BLK_DEV_THROTTLING)	+= blk-throttle.o
>  obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
>  obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
>  obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
> +obj-$(CONFIG_IOSCHED_BFQ)	+= bfq-iosched.o

Doesn't this break builds where BFQ is enabled including all-y/m?
Please make the config / makefile changes with the actual
implementation.

Thanks.

-- 
tejun
