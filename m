Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaIDQxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:53:34 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37166 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaIDQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <1409409935-8775-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409409935-8775-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Thu, 4 Sep 2014 18:53:28 +0200
Message-ID: <CACRpkdbYP3AMZEyeJnS0H6rgMs2sPOaW4xvRSnRVDLs=ahk=jA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: st: Add remove function and remove gpio_chip on failure
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 4:45 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch adds a remove function to platform_driver to unload
> the driver in a cleaner way. This also releases gpiochip related
> resources by calling gpiochip_remove when gpiochip_irqchip_add fails.
>
> CC: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
> CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.com>
> CC: Maxime Coquelin <maxime.coquelin@st.com>
> CC: Patrice Chotard <patrice.chotard@st.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Srinivas/Patrice: can you have a look at this?

Yours,
Linus Walleij
