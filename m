Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3AUNvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:51:16 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:52987 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3AUNvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:51:15 -0500
MIME-Version: 1.0
In-Reply-To: <1358175470-5041-1-git-send-email-lee.jones@linaro.org>
References: <1358175470-5041-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 21 Jan 2013 14:51:14 +0100
Message-ID: <CACRpkdYydqJ+BVsh7P411zCod+83f2pVV5tPsKfoWPYUnOVpDQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Disable Power Supply and Battery
 Management by default
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 3:57 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The AB8500 Battery Management collection of drivers are more than a
> little bit broken. There is lots of work still on-going in that area
> and it's improving day by day; however, it's not ready to be enabled
> by default just yet.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Is this going for fixes (v3.8?)

For v3.9 I think you've submitted a whole lot of patches
actually fixing it up?

Anyway: Acked-by: Linus Walleij <linus.walleij@linaro.org>
since you certainly know the status of this driver better than
me.

Yours,
Linus Walleij
