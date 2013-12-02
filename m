Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3LBCLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 21:11:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3LBCLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 21:11:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131129222327.GK21755@mtj.dyndns.org>
References: <1385441017-5773-1-git-send-email-ming.lei@canonical.com>
	<20131129222327.GK21755@mtj.dyndns.org>
Date: Mon, 2 Dec 2013 10:11:21 +0800
Message-ID: <CACVXFVMHsZO670rjMNcbWfutLSQv=YwkfN6_vc2WO8v2ie1t6w@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] lib/scatterlist: export sg_miter_skip()
From: Ming Lei <ming.lei@canonical.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 6:23 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Nov 26, 2013 at 12:43:37PM +0800, Ming Lei wrote:
>> sg_copy_buffer() can't meet demand for some drrivers(such usb
>> mass storage), so we have to use the sg_miter_* APIs to access
>> sg buffer, then need export sg_miter_skip() for these drivers.
>>
>> The API is needed for converting to sg_miter_* APIs in USB storage
>> driver for accessing sg buffer.
>>
>> Acked-by: Andrew Morton <akpm@linux-foundation.org>
>> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>
> Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

> I suppose this should go through -mm?

Last round, Andrew said it can be though whatever tree, so
given dependency reason, it is better to merge via greg's tree.

Greg, could you merge these two patches via your usb-next tree?

Thanks,
--
Ming Lei
