Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaIBM20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:28:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37317 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaIBM2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <1409299909-5128-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409299909-5128-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 2 Sep 2014 14:28:24 +0200
Message-ID: <CACRpkdZx1TAOFHJpx99oCuws3oK5W9rpXug5+DSkrDW-EhNzeA@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: qcom: remove gpiochip in failure cases
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 10:11 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch releases gpiochip related resources by calling
> gpiochip_remove when either of gpiochip_add_pin_range and
> gpiochip_irqchip_add fails.
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>
> Changes since v1:
> - In v1 of this patch gpiochip_remove was called only in failure case of
>   gpiochip_irqchip_add. This patchs adds a call to gpiochip_remove in failure
>   case of gpiochip_add_pin_range as well.

Patch applied with Björn's ACK.

Yours,
Linus Walleij
