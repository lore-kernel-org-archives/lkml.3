Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaIWOyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:54:05 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:45861 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaIWOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:54:00 -0400
MIME-Version: 1.0
In-Reply-To: <1410249101-12234-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1410249101-12234-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 23 Sep 2014 16:53:59 +0200
Message-ID: <CACRpkdZkQB_zTuvQA-8T=qMK7jgHPJQ3fZV_25haEnkJ8Loo9A@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: st: remove gpiochip in failure cases
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 9:51 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch releases gpiochip related resources by calling
> gpiochip_remove when gpiochip_irqchip_add fails.
>
> CC: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
> CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.com>
> CC: Maxime Coquelin <maxime.coquelin@st.com>
> CC: Patrice Chotard <patrice.chotard@st.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
> Changes since v1:
> Dropped adding remove function as it will never be tested as
> the driver is bool.

Patch applied with Srinivas ACK.

Yours,
Linus Walleij
