Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3AWKBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:01:10 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56546 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3AWKBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:01:09 -0500
MIME-Version: 1.0
In-Reply-To: <1358775340-8197-1-git-send-email-lee.jones@linaro.org>
References: <1358775340-8197-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 23 Jan 2013 11:01:08 +0100
Message-ID: <CACRpkdZY2+5fQ7m8wcbfzJTt-rX7RJPPN5mQ=waPrXV2m7sqDg@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Turn on the 'heartbeat' LED trigger
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 2:35 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The heartbeat LED trigger provides an excellent debugging tool
> when hacking on development boards. Here we enable it on all
> u8500 based platforms. This will pulse the User LED on the
> Snowball low-cost development board only.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-defconfig branch.

Thanks,
Linus Walleij
