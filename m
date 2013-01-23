Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3AWIui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:50:38 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51463 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3AWIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:50:37 -0500
MIME-Version: 1.0
In-Reply-To: <1358877374-1279-1-git-send-email-swarren@wwwdotorg.org>
References: <1358877374-1279-1-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 23 Jan 2013 09:50:36 +0100
Message-ID: <CACRpkdZTwvdmRnDOAcOObj7NhkuUunACpYBvAE1bY65suroQiA@mail.gmail.com>
Subject: Re: [PATCH V5] drivers/pinctrl: grab default handles from device core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK!

This modified version of the patch is way more beautiful, stupid
me for not realizing it could be written like that.

And I can sure live with the removed doc piece ... we can discuss
that separately if need be, I have some argument for it but it's
a separate issue.

I've dubbed this version the v5 variant and applied it, and included
the changelog (so I remember how it came about).

Greg/Mark: are you still confident with your ACK/Reviewed-by
tags being added on this version?

Yours,
Linus Walleij
