Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3K2WXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:23:33 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:63508 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3K2WXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:23:31 -0500
Date: Fri, 29 Nov 2013 17:23:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v1 1/2] lib/scatterlist: export sg_miter_skip()
Message-ID: <20131129222327.GK21755@mtj.dyndns.org>
References: <1385441017-5773-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385441017-5773-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 12:43:37PM +0800, Ming Lei wrote:
> sg_copy_buffer() can't meet demand for some drrivers(such usb
> mass storage), so we have to use the sg_miter_* APIs to access
> sg buffer, then need export sg_miter_skip() for these drivers.
> 
> The API is needed for converting to sg_miter_* APIs in USB storage
> driver for accessing sg buffer.
> 
> Acked-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

I suppose this should go through -mm?

Thanks.

-- 
tejun
