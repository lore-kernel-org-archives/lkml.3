Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbbAOQRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:17:47 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53261 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbbAOQRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:17:45 -0500
MIME-Version: 1.0
In-Reply-To: <1421142117-16371-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1421142117-16371-1-git-send-email-ricardo.ribalda@gmail.com>
Date: Thu, 15 Jan 2015 17:17:44 +0100
Message-ID: <CACRpkdaqdw39CO5OuOaawf7rwiKc6uVqGoak=BOSowSpzBH9tg@mail.gmail.com>
Subject: Re: [PATCH] gpio/Kconfig: Fix X86 arch name
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:41 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> X86 Kconfig symbol is X86, not ARCH_X86.
>
> Fixes: c586b3075d5b47d8 (gpio/xilinx: Add support for X86 Arch)
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

OK patch applied, let's see if the autobuilders puke on us now...

Yours,
Linus Walleij
