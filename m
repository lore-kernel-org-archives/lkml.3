Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaBJRkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:40:17 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57896 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaBJRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:40:14 -0500
Message-ID: <52F90EF9.9070406@kernel.dk>
Date: Mon, 10 Feb 2014 10:40:09 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] block: Fix type mismatch in ssize_t_blk_mq_tag_sysfs_show
References: <1392053278-2188-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1392053278-2188-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/10/2014 10:27 AM, Masanari Iida wrote:
> cppcheck detected following format string mismatch.
> [blk-mq-tag.c:201]: (warning) %u in format string (no. 1) requires
> 'unsigned int' but the argument type is 'int'.
>
> Change "cpu" from int to unsigned int, because the cpu
> never become minus value.

Thanks, applied.

-- 
Jens Axboe
