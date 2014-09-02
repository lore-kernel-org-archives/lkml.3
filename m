Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaIBM3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:29:30 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50871 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaIBM32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:29:28 -0400
MIME-Version: 1.0
In-Reply-To: <1409137049-15848-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409137049-15848-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 2 Sep 2014 14:29:27 +0200
Message-ID: <CACRpkdadZbpsZBdhUn9xBSNfsL1+H-T2y5KejmSQsoTtdyBUaw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: qcom: Release pin ranges when
 gpiochip_irqchip_add fails
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 12:57 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patches adds a call to gpiochip_remove_pin_ranges when
> gpiochip_irqchip_add fails to release memory allocated for pin_ranges.
>
> CC: Ivan T. Ivanov <iivanov@mm-sol.com>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Dropping this one as the gpiochip_remove() patch fixes the
problem.

Yours,
Linus Walleij
