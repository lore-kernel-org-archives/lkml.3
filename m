Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaKYHrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:47:02 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:54393 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKYHrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:47:00 -0500
MIME-Version: 1.0
In-Reply-To: <20141124131200.GA28582@phare.normalesup.org>
References: <20141124131200.GA28582@phare.normalesup.org>
Date: Tue, 25 Nov 2014 15:46:59 +0800
Message-ID: <CANLX1YEJBZE-1v3KBfPRjZiYad0Db_UJPE+xpJXFC9ebM5081Q@mail.gmail.com>
Subject: Re: Using kernel filesystems as userland libraries
From: xun ni <ni.xun.intel@gmail.com>
To: Nicolas George <george@nsup.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, George:

   is there any reason to do this? we still need to copy files from
userspace to kernel.

Thanks,
Xun

2014-11-24 21:12 GMT+08:00 Nicolas George <george@nsup.org>:
> Hi.
>
> With the libraries present in e2fsprogs, it is possible to open a plain file
> (or any other reasonable storage) as an EXT2 filesystem and manipulate files
> inside it.
>
> Is it possible to use the implementations in the kernel to do the same thing
> with any supported normal filesystem?
>
> Obviously, it is theoretically possible, but my question is whether it has
> been done in practice. I suppose it would require writing userland
> replacement for the kernel APIs (memory management, access to block devices,
> scheduling) and either rebuilding the kernel source as userland code or
> loading the modules directly.
>
> Regards,
>
> --
>   Nicolas George
