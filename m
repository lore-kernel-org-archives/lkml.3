Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3IXVMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:12:16 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:50684 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3IXVMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:12:14 -0400
Message-ID: <5242002A.6050507@converseincode.com>
Date: Tue, 24 Sep 2013 17:12:10 -0400
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: balbi@ti.com
CC: charlebm@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH] Remove VLAIS usage from gadget code - alternate patch
References: <1380045419-10367-1-git-send-email-charlebm@gmail.com>
In-Reply-To: <1380045419-10367-1-git-send-email-charlebm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/13 13:56, charlebm@gmail.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
>
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
> precludes the use of compilers which don't implement VLAIS (for instance the
> Clang compiler). This alternate patch calculates offsets into the kmalloc-ed
> memory buffer using macros. The previous patch required multiple kmalloc and
> kfree calls.
>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
This one uses macros and carves up a single piece of memory from one 
kmalloc.

Behan

-- 
Behan Webster
behanw@converseincode.com

