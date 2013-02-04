Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3BDJN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:13:59 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:35465 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3BDJN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:13:57 -0500
MIME-Version: 1.0
In-Reply-To: <1359965415-3887-1-git-send-email-agust@denx.de>
References: <1359461275-7059-1-git-send-email-agust@denx.de>
	<1359965415-3887-1-git-send-email-agust@denx.de>
Date: Mon, 4 Feb 2013 10:13:56 +0100
Message-ID: <CACRpkdZfrXkK3RLgDRwey28JQPHEkyZyQa9RmjzKCP3wrzxQjg@mail.gmail.com>
Subject: Re: [PATCH] gpio: mpc8xxx: don't set IRQ_TYPE_NONE when creating irq mapping
From: Linus Walleij <linus.walleij@linaro.org>
To: Anatolij Gustschin <agust@denx.de>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Peter Korsgaard <jacmet@sunsite.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 9:10 AM, Anatolij Gustschin <agust@denx.de> wrote:

> Exporting gpios over sysfs GPIO interface throws genirq
> error messages, i.e. on an mpc5121 based board exporting
> GPIO 5 triggers it:

Thanks, I'm convinced now. Applied the v2 patch!

Yours,
Linus Walleij
