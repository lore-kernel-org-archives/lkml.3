Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbaLNSRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:17:17 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:36907 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaLNSRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:17:16 -0500
Date: Sun, 14 Dec 2014 18:49:51 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Manish Yadav <kmanish.ixp@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: need help to clear kernel (2.6.16.17) cached memory
Message-ID: <20141214184951.5df2c128@neptune.home>
In-Reply-To: <CAJ-jhEfRdFjTKBtLKYjVKwxD5bR4qLftXnKiySShrj4CmcfAqw@mail.gmail.com>
References: <CAJ-jhEfRdFjTKBtLKYjVKwxD5bR4qLftXnKiySShrj4CmcfAqw@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 13 December 2014 Manish Yadav <kmanish.ixp@gmail.com> wrote:
> on my system (based on 2.6.16.17), i am trying to clear the cached
> memory but it is not being cleared.
> 
> mars# free -m
>              total       used       free     shared    buffers     cached
> Mem:           925        459        465          0          0        231
> -/+ buffers/cache:        228        697
> Swap:            0          0          0
> mars# sync && echo 3 > /proc/sys/vm/drop_caches
> M1450-mrakesh# free -m
>              total       used       free     shared    buffers     cached
> Mem:           925        459        466          0          0        231
> -/+ buffers/cache:        227        697
> Swap:            0          0          0
> mars#
> 
> could you please let me know what i am missing here? as per my
> investigation writing 3 to drop_caches should clear the cached memory.

Any tmpfs around that would be filled with the remaining cached data?

> thanks,
> manish

Cheers,
Bruno
