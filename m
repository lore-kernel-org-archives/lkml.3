Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbaLLIoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:44:20 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61318 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbaLLIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:44:19 -0500
MIME-Version: 1.0
In-Reply-To: <1418155343.2058.99.camel@x220>
References: <1418155343.2058.99.camel@x220>
Date: Fri, 12 Dec 2014 16:44:17 +0800
X-Google-Sender-Auth: NvbepIVKfD_uXtF1cQqkMsNzvww
Message-ID: <CAFiDJ5_=xLtYdhbXj3K1tAqv_9P2kQG4WArE1hQwoRr8=h4VOA@mail.gmail.com>
Subject: Re: [PATCH] nios2: enable "make defconfig"
From: Ley Foon Tan <lftan@altera.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "nios2-dev@lists.rocketboards.org" <nios2-dev@lists.rocketboards.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 4:02 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Running "make defconfig" currently fails for nios2:
>     $ make ARCH=nios2 defconfig
>     scripts/kconfig/conf --defconfig Kconfig
>     ***
>     *** Can't find default configuration "arch/nios2/defconfig"!
>     ***
>     make[1]: *** [defconfig] Error 1
>     make: *** [defconfig] Error 2
>
> Add a definition for KBUILD_DEFCONFIG to the nios2's main Makefile to
> enable this make target.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
Applied.

Thanks.
