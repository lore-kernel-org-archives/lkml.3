Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab3HNPeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:34:31 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:48064 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3HNPe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <1373972146-12133-2-git-send-email-sonic.adi@gmail.com>
References: <1373972146-12133-1-git-send-email-sonic.adi@gmail.com>
	<1373972146-12133-2-git-send-email-sonic.adi@gmail.com>
Date: Wed, 14 Aug 2013 17:34:29 +0200
Message-ID: <CACRpkdZ5wtNmvQw1pqponows-VPrEN9KBYosTyDJhcrU2+mB9w@mail.gmail.com>
Subject: Re: [PATCH 2/3] blackfin: gpio: Remove none gpio lib code.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        buildroot-devel@blackfin.uclinux.org,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:55 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> - Remove non gpio lib code from blackfin architecture.
> - Limit the lagecy blackfin gpio driver to bf5xx processors only.
> - Remove unused definition of the pint power functions.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

This seems fine.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
