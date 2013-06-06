Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab3FFCkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:40:07 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:50566 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3FFCkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130606022959.GF13110@ZenIV.linux.org.uk>
References: <20130606012010.GE13110@ZenIV.linux.org.uk>
	<CA+55aFxB9GRfxhCg+s3xMCUQ5Sjt+nViRHQA-DPJ_5DB+v57Uw@mail.gmail.com>
	<20130606022959.GF13110@ZenIV.linux.org.uk>
Date: Thu, 6 Jun 2013 11:40:04 +0900
X-Google-Sender-Auth: atPEKBoyiIbbUt8mHNjsrfCVzIw
Message-ID: <CA+55aFzh3EFgk3-Jzyd=VGKu=+tyn6XeCw29t53p=wcfFdiczA@mail.gmail.com>
Subject: Re: [RFC] corner cases of open() on procfs symlinks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 11:29 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Probably...  procfs symlinks neutering O_DIRECTORY might, in theory, be usable
> to cook something nasty, but I don't see any obvious ways to exploit that.
> FWIW, resulting kernel seems to survive the minimal beating, but obviously
> more is needed.

Let's plan on merging that patch in the 3.11 merge window, and perhaps
mark it for stable?

                 Linus
