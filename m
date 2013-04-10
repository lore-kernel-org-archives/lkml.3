Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937315Ab3DJKkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:40:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48134 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3DJKkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:40:33 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130410184852.92a3a02bbe5c3a040be76365@canb.auug.org.au>
References: <20130410184852.92a3a02bbe5c3a040be76365@canb.auug.org.au>
Date: Wed, 10 Apr 2013 12:40:32 +0200
Message-ID: <CA+icZUWYHv5h26Q6xr30=UxavD52ZX6W1vfTKj8n6gyuCz0q3g@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 10
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:48 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130409:
>
> The vfs tree lost its build failure.
>

Beyond build-failures in vfs-next [0] and [1], it was not bootable
(see [2] till [4])!
This is now all fixed, thanks to all involved people!

$ cat /proc/version
Linux version 3.9.0-rc6-next20130410-1-iniza-small
(sedat.dilek@gmail.com@fambox) (gcc version 4.6.3 (Ubuntu/Linaro
4.6.3-1ubuntu5) ) #1 SMP Wed Apr 10 11:55:58 CEST 2013

NOTE: There still exists the NULL-pointer-deref in cpufreq for me on
Intel SandyBridge CPU (see [5]) on reboot and when CPUs get offline.

- Sedat -

[0] https://lkml.org/lkml/2013/4/7/229
[1] http://marc.info/?l=linux-next&m=136552249527170&w=2
[2] http://marc.info/?t=136545773000008&r=1&w=2
[3] http://marc.info/?t=136545603700003&r=1&w=2
[4] http://marc.info/?l=linux-next&m=136552718229123&w=2
[5] http://marc.info/?t=136551588400003&r=1&w=2
