Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3K1Ock (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:32:40 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37717 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3K1Oci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <1385372064-16221-1-git-send-email-acourbot@nvidia.com>
References: <529317AB.1050600@nvidia.com>
	<1385372064-16221-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 28 Nov 2013 15:32:37 +0100
Message-ID: <CACRpkdZMjmmUN0LkAZiBU8Dvy74zFZ2fQhRxeUMWbTfXupVzoA@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: add missing declarations
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 10:34 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Add declaration of 'struct of_phandle_args' to avoid the following
> warning:
>
>   In file included from arch/arm/mach-tegra/board-paz00.c:21:0:
>   include/linux/gpio/driver.h:102:17: warning: 'struct of_phandle_args' declared inside parameter list
>   include/linux/gpio/driver.h:102:17: warning: its scope is only this definition or declaration, which is probably not what you want
>
> Also proactively add other definitions/includes that could be missing
> in other contexts.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reported-by: Stephen Warren <swarren@wwwdotorg.org>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied for fixes.

Yours,
Linus Walleij
