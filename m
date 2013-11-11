Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3KKNRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:17:37 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:62516 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3KKNRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:17:32 -0500
MIME-Version: 1.0
In-Reply-To: <20131111150507.0bb1083e@mdontu-l>
References: <CAK2Ky6yh6U1wiAAPC9TgWduzO4NS9Km0FGgRvMntTm=qYkWt7A@mail.gmail.com>
	<20131111150507.0bb1083e@mdontu-l>
Date: Mon, 11 Nov 2013 21:17:31 +0800
Message-ID: <CAK2Ky6wxDJnz3t9zK_Mumad4bsQnM_kzKds1bvhwYKQ98v3adw@mail.gmail.com>
Subject: Re: Linux kernel API about sector count
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you! I need disk's total count of sector,not the sector size.

2013/11/11 Mihai Donțu <mihai.dontu@gmail.com>:
> On Mon, 11 Nov 2013 20:31:14 +0800 韩磊 wrote:
>> Can you tell me the API about the count of sector in linux kernel?
>>
>> which .h file and function?
>>
>
> Looking at fdisk (util-linux) there are several ioctls:
>  * HDIO_GETGEO  (linux/hdreg.h)
>  * BLKGETSIZE64 (linux/fs.h), sector size is assumed 512
>
> The HDIO interface *seems* to be legacy:
> http://www.mjmwired.net/kernel/Documentation/ioctl/hdio.txt
>
> Also see:
> https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/fdisks/fdisk.c
>
> I hope this helps a bit.
>
> --
> Mihai Donțu
