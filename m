Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbaEILll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:41:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35714 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEILli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <1398860616-6612-4-git-send-email-grygorii.strashko@ti.com>
References: <1398860616-6612-1-git-send-email-grygorii.strashko@ti.com>
	<1398860616-6612-4-git-send-email-grygorii.strashko@ti.com>
Date: Fri, 9 May 2014 13:41:38 +0200
Message-ID: <CACRpkdZWaDvqec1T_0kwEo=v7abmvLpay-DvYbWKr19y3PN=XA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] net: davinci_mdio: drop pinctrl_pm_select_default_state
 from probe
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 2:23 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> The "default" pinctrl state is set by Drivers core now before
> calling the driver's probe.
> Hence, it's safe to drop pinctrl_pm_select_default_state() call
> from Davinci mdio driver probe.
>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Acked-and-tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
