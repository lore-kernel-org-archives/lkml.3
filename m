Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaL2DAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 22:00:46 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58242 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaL2DAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 22:00:44 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 29 Dec 2014 12:02:47 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zram: clean up zram_meta_alloc()
Message-ID: <20141229030247.GD27095@bbox>
References: <1419172541-26173-1-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419172541-26173-1-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:35:41PM +0900, Sergey Senozhatsky wrote:
> a trivial clean up of zram_meta_alloc() error handling.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
