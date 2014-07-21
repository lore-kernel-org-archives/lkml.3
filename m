Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaGUJ6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:58:48 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59372 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaGUJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:58:47 -0400
MIME-Version: 1.0
Date: Mon, 21 Jul 2014 12:58:45 +0300
Message-ID: <CACVxJT-C6_7hVTfrGQ7fH1VbBTQF9tJ1raNU5QuA2BR1J1sY5Q@mail.gmail.com>
Subject: Re: [PATCH 2/9] fs.h: Whitespace neatening
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
> +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)

> -#define KERNEL_READ (READ|REQ_KERNEL)
> -#define KERNEL_WRITE (WRITE|REQ_KERNEL)
> +#define KERNEL_READ (READ | REQ_KERNEL)
> +#define KERNEL_WRITE (WRITE | REQ_KERNEL)

I understand that you have no clue about what is important and what is not,
but at least do no pollute git-blame with your prototype and other oh so
important changes.

Sincerely Yours, A
