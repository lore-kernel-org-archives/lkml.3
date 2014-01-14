Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaANJpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:45:24 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51055 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaANJpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:45:20 -0500
Date: Tue, 14 Jan 2014 12:42:14 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] zram stats rework and code cleanup
Message-ID: <20140114094214.GA2180@swordfish.minsk.epam.com>
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/14/14 12:37), Sergey Senozhatsky wrote:
> This patchset includes code clean up and zram stats rework.
> 

forgot to mention. this patchset based on top of Minchan's
patchset.

	-ss

> Sergey Senozhatsky (3):
>   zram: drop `init_done' struct zram member
>   zram: do not pass rw argument to __zram_make_request()
>   zram: rework reported to end-user zram statistics
> 
>  drivers/block/zram/zram_drv.c | 213 ++++++++++++++----------------------------
>  drivers/block/zram/zram_drv.h |  18 ++--
>  2 files changed, 76 insertions(+), 155 deletions(-)
> 
> -- 
> 1.8.5.2.487.g7559984
> 
