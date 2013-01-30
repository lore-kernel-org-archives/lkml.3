Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3A3SI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:08:56 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:42766 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab3A3SIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130130170750.GA5217@gmail.com>
References: <1359563102-5934-1-git-send-email-linus.walleij@stericsson.com>
	<51094E50.4000302@wwwdotorg.org>
	<20130130170750.GA5217@gmail.com>
Date: Wed, 30 Jan 2013 19:08:51 +0100
Message-ID: <CACRpkdZ_4kaEFHmLvgfrsimg7YSY2gnfsQMVfzcYniVT-oR+jQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: nomadik: Rename Device Tree compatible string
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 6:07 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The preference is to use '-' instead of '_' in compatible strings.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

This does not apply to pinctrl devel. (Same as linux-next)

This is because the two hunks, as compared to the last patch,
were already in-tree, they were changed as part of patch:

commit e32af889458837d11a1ec5ec98934a1e711b049d
Author: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Date:   Mon Dec 17 15:53:24 2012 +0100

    pinctrl/nomadik: add device tree support

    This implements pin multiplexing and pin configuration for
    the Nomadik pin controller using the device tree.

    Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
    Reviewed-by: Stephen Warren <swarren@nvidia.com>
    Reviewed-by: Philippe Langlais <philippe.langlais@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Since I don't dare to squash this oneliner into that patch
for fear of Lee's rage, I leave the old patch as it is.

Yours,
Linus Walleij
