Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaK1L5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:57:18 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37137 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaK1L5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:57:17 -0500
MIME-Version: 1.0
In-Reply-To: <1416644843-18304-1-git-send-email-kishon@ti.com>
References: <1416644843-18304-1-git-send-email-kishon@ti.com>
Date: Fri, 28 Nov 2014 12:57:16 +0100
Message-ID: <CACRpkdbX2KxrvBniTd3yjWasHg8C5cuJ2o_eV6ymWtfaFk76SA@mail.gmail.com>
Subject: Re: [PATCH] phy: remove the old lookup method
From: Linus Walleij <linus.walleij@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        gautam.vivek@samsung.com, andrew.kim@intel.com,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 9:27 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:

> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>
> The users of the old method are now converted to the new one.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> [ kishon@ti.com : made phy-berlin-usb.c and phy-miphy28lp.c to use the updated
>                   devm_phy_create API.]
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> Two new PHY drivers phy-berlin-usb.c and phy-miphy28lp.c were added which was using the old
> devm_phy_create signature. Made it to use the new devm_phy_create signatiure.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess this will be applied to the PHY tree.

Yours,
Linus Walleij
