Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaDWOYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:24:37 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:38833 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbaDWOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:24:29 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
References: <CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
	<20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
	<52D90B93.5010209@gmail.com>
	<20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
	<53523D16.9020101@gmail.com>
	<201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
Date: Wed, 23 Apr 2014 16:24:28 +0200
Message-ID: <CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 2:08 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Michael Kerrisk (man-pages) wrote:
>> Now that renameat2() is in 3.15, I've taken these changes.
>
> What!? I didn't know renameat2() goes to 3.15.
>
> But I assume that renameat2() is not accessible in 3.15, for I can see
> "asmlinkage long sys_renameat2(" but don't see "#define __NR_renameat2".

x86 automatically generates __NR_foo entries and syscall tables from
arch/x86/syscalls/syscall_*.tbl, which is why you don't find an
explicit definition in the git tree.

Thanks,
Miklos
