Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716Ab3BIOb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:31:27 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:50205 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676Ab3BIOb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:31:26 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] gpio: mcp23s08: convert driver to DT
To: Lars Poeschel <larsi@wh2.tu-dresden.de>, poeschel@lemonage.de,
        rob.herring@calxeda.com, rob@landley.net, linus.walleij@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org
In-Reply-To: <1360170118-11937-3-git-send-email-larsi@wh2.tu-dresden.de>
References: <1360170118-11937-1-git-send-email-larsi@wh2.tu-dresden.de> <1360170118-11937-3-git-send-email-larsi@wh2.tu-dresden.de>
Date: Sat, 09 Feb 2013 14:31:20 +0000
Message-Id: <20130209143120.AA32B3E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Feb 2013 18:01:58 +0100, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This converts the mcp23s08 driver to be able to be used with device
> tree.
> There is a special "mcp,chips" property, that correspond to the chips
> member of the struct mcp23s08_platform_data. It can be used for
> multiple mcp23s08/mc23s17 on the same spi chipselect.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Ah, ignore my previous email. You did convert the driver. I've applied
the two patches. Actually I squashed them together since they really
were one logical change.

g.

