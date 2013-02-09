Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3BIKKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:10:10 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47010 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3BIKKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:10:04 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/9] gpiolib: use gpio_chips list in gpiolib_sysfs_init
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
In-Reply-To: <CACRpkdaz8h_1uKoH1q9gLmCxE0BMAxBakaq_eFfnfJr2V_Ct5w@mail.gmail.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-4-git-send-email-acourbot@nvidia.com> <CACRpkdaz8h_1uKoH1q9gLmCxE0BMAxBakaq_eFfnfJr2V_Ct5w@mail.gmail.com>
Date: Sat, 09 Feb 2013 09:22:32 +0000
Message-Id: <20130209092232.64D0A3E2C01@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013 18:04:43 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
> > Use the small list of GPIO chips instead of parsing the whole GPIO
> > number space.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 

Applied, thanks.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
