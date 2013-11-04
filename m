Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3KDW7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:59:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43379 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KDW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:58:59 -0500
Message-ID: <527826A1.1060309@kernel.dk>
Date: Mon, 04 Nov 2013 15:58:41 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [virtio_blk] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:526 sysfs_add_one()
References: <20131104141012.GA17177@localhost>
In-Reply-To: <20131104141012.GA17177@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 07:10 AM, Fengguang Wu wrote:
> Hi Jens,
> 
> I'm not very sure about this bisect, but anyway it'd be good to inform
> you of a possible problem on commit
> 
> commit 3a02db083a78c9f3c9b69305ab513f9422d91b08
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri May 24 20:22:33 2013 +0200
> 
>     virtio_blk: blk-mq support
>     
>     Pretend we have 4 issue queues.
>     
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>

What git branch are you on? That one is outdated.

-- 
Jens Axboe

