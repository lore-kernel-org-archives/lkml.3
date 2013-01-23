Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3AWJgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:36:51 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:65257 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3AWJgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:36:49 -0500
MIME-Version: 1.0
In-Reply-To: <1357725965-27342-3-git-send-email-lee.jones@linaro.org>
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
	<1357725965-27342-3-git-send-email-lee.jones@linaro.org>
Date: Wed, 23 Jan 2013 10:36:49 +0100
Message-ID: <CACRpkdbgQP1ahFjHtCFeAcQzxHY3LvVidJFL0FfbwOOAZU5fAA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: ux500: Add Snowball pin configuration for user LED
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 11:06 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we setup the GPIO pin responsible for illuminating the user
> LED on the Snowball low-cost development board.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my ux500 tree, branch ux500-pinctrl.

Yours,
Linus Walleij
