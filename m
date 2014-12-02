Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaLBIb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:31:28 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45403 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaLBIb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWWnO7m8f+NnM8Xahexc+3ELeAgTDv67CzWWEZENqztEA@mail.gmail.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-3-git-send-email-oakad@yahoo.com>
	<CAMuHMdWWnO7m8f+NnM8Xahexc+3ELeAgTDv67CzWWEZENqztEA@mail.gmail.com>
Date: Tue, 2 Dec 2014 19:31:26 +1100
Message-ID: <CAPs88r-pzz86GJLv-QPEAc7AsBZLDwffrD-J633_xqR5cHVUTA@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs: Wire up sendfd() syscall (all architectures)
From: Alex Dubov <alex.dubov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 7:01 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> This really needs a CC to linux-arch (added).
>
>
> You forgot to update NR_syscalls in arch/m68k/include/asm/unistd.h.
>

Noted. I would assume that other architectures may have similar
problems (I only tested
my submission on x86_64).

Will try to fix those when/if there's progress toward accepting the
proposed feature.
