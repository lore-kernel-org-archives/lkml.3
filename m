Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3BKAW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:22:26 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45515 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3BKAWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:22:24 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 5/6] of_spi: Add fetching of of_gpio flags to of_spi_register_master
To: Andreas Larsson <andreas@gaisler.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1359471223-4794-6-git-send-email-andreas@gaisler.com>
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com> <1359471223-4794-6-git-send-email-andreas@gaisler.com>
Date: Mon, 11 Feb 2013 00:22:20 +0000
Message-Id: <20130211002220.AFCA83E0C13@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 15:53:42 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> When using a gpio chip select with a OF_GPIO_ACTIVE_LOW flag, this needs to be
> known to the controller driver.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Out of curiosity, what do you need the flags for? Polarity of the CS
signal? I think it is long past time to revisit baking polarity control
into core of gpiolib. Would you mind investigating doing that instead of
having to manage it manually in each and every driver?

g.

