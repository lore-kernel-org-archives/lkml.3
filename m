Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaIDRWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:22:12 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:44179 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbaIDRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <1409767315-8288-1-git-send-email-geert+renesas@glider.be>
References: <1409767315-8288-1-git-send-email-geert+renesas@glider.be>
Date: Thu, 4 Sep 2014 19:22:09 +0200
Message-ID: <CACRpkdbkU=H+-Mz-movoP4=ro3a8eo-vm1rcnR7Q9q7qSWwyDg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: generic: Fix PIN_CONFIG_DRIVE_OPEN_SOURCE
 source/drain doc mismatch
From: Linus Walleij <linus.walleij@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 8:01 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:

> PIN_CONFIG_DRIVE_OPEN_SOURCE enables open source, not open drain.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Yes, we need more open source ;-)

Yeah, patch applied!

Yours,
Linus Walleij
