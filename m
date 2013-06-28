Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3F1P3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:29:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3F1P3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:29:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Liang Li <liang.li@windriver.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: request for stable inclusion
References: <51CD518B.2050106@huawei.com>
Date: Fri, 28 Jun 2013 16:29:27 +0100
In-Reply-To: <51CD518B.2050106@huawei.com> (Yijing Wang's message of "Fri, 28
	Jun 2013 17:04:11 +0800")
Message-ID: <871u7m8d9k.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yijing Wang <wangyijing@huawei.com> writes:

> Hi Greg, Jiri or Liang Li
>
> 384e301e3519599b000c1a2ecd938b533fc15d85
> pch_uart: fix a deadlock when pch_uart as console
>
> This looks applicable to stable-3.4, and it
> was built successful for me. What do you think?
>
> Thanks!
> Yijing.
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm queuing it for the 3.5 as well.

Also, this seems to be applicable to older kernels as well.

Cheers,
-- 
Luis
