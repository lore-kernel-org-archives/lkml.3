Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3HGNsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:48:17 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64679 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab3HGNsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <1374243229-8585-14-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
	<1374243229-8585-14-git-send-email-lee.jones@linaro.org>
Date: Wed, 7 Aug 2013 15:48:16 +0200
Message-ID: <CACRpkdarR1_ytczATc3+6wvSeXg5gLd+W47vp3gqRC3O1i95GA@mail.gmail.com>
Subject: Re: [PATCH 13/13] ARM: ux500: Remove u9540.dts as it's been replaced
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 4:13 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This must have been a merge error. There was a patch which renamed the
> u9540.dts to ccu9540.dts, however the u9540.dts was reincarnate with
> the same patches which created it in the first place. Let's kill it
> once and for all.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I applied all the rename patches but it appears they were never
really tested, so I made this patch fixing all the bugs they introduced.
(Quicker than iterating the patch set.)

Yours,
Linus Walleij
