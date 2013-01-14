Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3ANIWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:22:55 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38702 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3ANIWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:22:54 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Alex Riesen <raa.lkml@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than 120 seconds"
Date: Mon, 14 Jan 2013 09:22:54 +0100
Message-ID: <2305064.Ot4klciZAj@linux-5eaq.site>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com> <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com> <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013 11:47:57 Ming Lei wrote:
> [  181.175323] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  181.183624] modprobe        D c04f1920     0  2462   2461 0x00000000
> [  181.183685] [<c04f1920>] (__schedule+0x5fc/0x6d4) from [<c005eba4>]
> (async_synchronize_cookie_domain+0xdc/0x
> 168)
> [  181.183715] [<c005eba4>]
> (async_synchronize_cookie_domain+0xdc/0x168) from [<c005ed04>]
> (async_synchronize_f
> ull+0x3c/0x60)
> [  181.183776] [<c005ed04>] (async_synchronize_full+0x3c/0x60) from
> [<c0085610>] (load_module+0x1aac/0x1cdc)
> [  181.183807] [<c0085610>] (load_module+0x1aac/0x1cdc) from
> [<c0085944>] (sys_init_module+0x104/0x110)
> [  181.183837] [<c0085944>] (sys_init_module+0x104/0x110) from
> [<c000dfe0>] (ret_fast_syscall+0x0/0x48)
> [  271.175506] INFO: task modprobe:2462 blocked for more than 90 seconds.
> [  271.182373] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  271.190826] modprobe        D c04f1920     0  2462   2461 0x00000000
> [  271.190887] [<c04f1920>] (__schedule+0x5fc/0x6d4) from [<c005eba4>]
> (async_synchronize_cookie_domain+0xdc/0x
> 168)
> [  271.190917] [<c005eba4>]
> (async_synchronize_cookie_domain+0xdc/0x168) from [<c005ed04>]
> (async_synchronize_f
> ull+0x3c/0x60)
> [  271.190948] [<c005ed04>] (async_synchronize_full+0x3c/0x60) from
> [<c0085610>] (load_module+0x1aac/0x1cdc)
> [  271.190948] [<c0085610>] (load_module+0x1aac/0x1cdc) from
> [<c0085944>] (sys_init_module+0x104/0x110)
> [  271.190979] [<c0085944>] (sys_init_module+0x104/0x110) from
> [<c000dfe0>] (ret_fast_syscall+0x0/0x48)

OK, your trace is totally different. If your hangs are related, as is likely,
my explanation goes out of the window.

	Regards
		Oliver

