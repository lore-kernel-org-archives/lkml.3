Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3BXLSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 06:18:33 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:46340 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3BXLSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 06:18:31 -0500
MIME-Version: 1.0
In-Reply-To: <5129F39D.10900@gmx.de>
References: <5129F39D.10900@gmx.de>
Date: Sun, 24 Feb 2013 12:18:29 +0100
Message-ID: <CAFLxGvx8hx42GX-u4850bqZu6doRabPKeLVGeQ1VDoO4_27TSA@mail.gmail.com>
Subject: Re: [uml-user] v3.8-6988-g9e2d59a compile error
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: user-mode-linux-user@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 12:03 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> Moin,
>
> got this wit the attached .config :
>
> ...
>   CC      kernel/mutex.o
>   CC      kernel/hrtimer.o
> kernel/mutex.c:34:37: error: include/asm-generic/mutex-null.h: Input/output error

The compiler got -EIO while opening include/asm-generic/mutex-null.h.
Maybe a you should fsck your disk first. :-)

-- 
Thanks,
//richard
