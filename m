Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab3JILIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:08:00 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50560 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3JILH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <1381217421-17198-1-git-send-email-sonic.adi@gmail.com>
References: <1381217421-17198-1-git-send-email-sonic.adi@gmail.com>
Date: Wed, 9 Oct 2013 13:07:58 +0200
Message-ID: <CACRpkdZc2gQ2gwpD2Rgvc-+xoEA_h-qRSM2ntbKwz_7qg52y2g@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: pinctrl-adi2: Remove nested lock+irqsave that
 resue flags.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 9:30 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Also avoid use NULL pointer in error message.
>
> v2-changes:
> - use port pinter only after checking
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Nice cleanup! Patch applied.

Yours,
Linus Walleij
