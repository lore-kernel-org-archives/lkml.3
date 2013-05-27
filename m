Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab3E0Lhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:37:39 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59087 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3E0Lhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:37:37 -0400
MIME-Version: 1.0
In-Reply-To: <1369394539-3713-1-git-send-email-lee.jones@linaro.org>
References: <1369394539-3713-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 27 May 2013 13:37:37 +0200
Message-ID: <CACRpkdZGHNG0uG+vicpQEQ0y61bAM0FTg-wMrZ3SbsW2Owf0PA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Provide supplies for AUX1, AUX2 and AUX3
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 1:22 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch fixes a bug introduced in the v3.10 merge window.
>
> The AB8500 External Regulator driver has recently landed upstream,
> which registers each of the 3 external regulators located on the
> AB8500. If these regulators are marked as 'always on', there is a
> potential for power-loss. If they're not and are seemingly unused
> the Regulator subsystem will attempt to disable them to save power.
> This causes an issue for AUX1, AUX2 and AUX3 as they obtain their
> power from EXT3. So we're specifying that here to prevent EXT3 from
> being powered down.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied for ux500-fixes, thanks!

Yours,
Linus Walleij
