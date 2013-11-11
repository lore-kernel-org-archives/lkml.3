Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3KKNFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:05:16 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:36744 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3KKNFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:05:11 -0500
Date: Mon, 11 Nov 2013 15:05:07 +0200
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: =?UTF-8?B?6Z+p56OK?= <bonben1989@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel API about sector count
Message-ID: <20131111150507.0bb1083e@mdontu-l>
In-Reply-To: <CAK2Ky6yh6U1wiAAPC9TgWduzO4NS9Km0FGgRvMntTm=qYkWt7A@mail.gmail.com>
References: <CAK2Ky6yh6U1wiAAPC9TgWduzO4NS9Km0FGgRvMntTm=qYkWt7A@mail.gmail.com>
Organization: Home
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013 20:31:14 +0800 韩磊 wrote:
> Can you tell me the API about the count of sector in linux kernel?
> 
> which .h file and function?
> 

Looking at fdisk (util-linux) there are several ioctls:
 * HDIO_GETGEO  (linux/hdreg.h)
 * BLKGETSIZE64 (linux/fs.h), sector size is assumed 512

The HDIO interface *seems* to be legacy:
http://www.mjmwired.net/kernel/Documentation/ioctl/hdio.txt

Also see:
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/fdisks/fdisk.c

I hope this helps a bit.

-- 
Mihai Donțu
