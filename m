Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3EFSv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:51:56 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:50737 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3EFSvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:51:55 -0400
MIME-Version: 1.0
In-Reply-To: <5187F9F5.7090501@fisher-privat.net>
References: <CA+8MBb++1CVLAo3zw4fx2O7akWsZcvybRyZpt0ac0sX7M=u5Xw@mail.gmail.com>
	<5187F9F5.7090501@fisher-privat.net>
Date: Mon, 6 May 2013 11:51:54 -0700
Message-ID: <CA+8MBbKhoNWRAHE93VNW9zNMerBpmbSuHfvhrR_JJcSRvqN6Vg@mail.gmail.com>
Subject: Re: VFAT complains that my file system may be corrupted
From: Tony Luck <tony.luck@gmail.com>
To: Oleksij Rempel <bug-track@fisher-privat.net>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 11:44 AM, Oleksij Rempel
<bug-track@fisher-privat.net> wrote:
> i provided patches for dosfstools for some time now, you need at least
> v3.0.14. If your system do not provide it you will need to grub it here:
> http://daniel-baumann.ch/gitweb/?p=software/dosfstools.git

I may have too old a toolchain to build those :-(

src/boot.c:560: warning: implicit declaration of function ‘cpu_to_le16’
src/boot.c:562: warning: implicit declaration of function ‘cpu_to_le32’

and then at link time:

/home/aegl/dosfstools/src/boot.c:560: undefined reference to `cpu_to_le16'
/home/aegl/dosfstools/src/boot.c:561: undefined reference to `cpu_to_le16'
/home/aegl/dosfstools/src/boot.c:562: undefined reference to `cpu_to_le32'

I guess I can fake them easily (ia64 runs little endian on Linux).

-Tony
