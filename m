Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3DNI0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 04:26:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48152 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3DNI0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 04:26:09 -0400
Date: Sun, 14 Apr 2013 10:25:39 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] mtip32xx: fix a smatch warning
Message-ID: <20130414082539.GF12244@kernel.dk>
References: <51685205.5080806@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51685205.5080806@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12 2013, Asai Thambi S P wrote:
> 
> Reported smatch warning:
> drivers/block/mtip32xx/mtip32xx.c:4163 mtip_block_shutdown() warn: variable dereferenced before check 'dd->disk' (see line 4159)
> 
> dd->disk->disk_name accessed before the check if dd->disk is NULL. Fixed this
> and access of dd->queue/dd->disk->queue.

Applied for 3.10, thanks.

-- 
Jens Axboe

