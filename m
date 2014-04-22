Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaDVPLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:11:47 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54324 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbaDVPLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:11:41 -0400
MIME-Version: 1.0
In-Reply-To: <1397531437-9104-1-git-send-email-agross@codeaurora.org>
References: <1397531437-9104-1-git-send-email-agross@codeaurora.org>
Date: Tue, 22 Apr 2014 17:11:40 +0200
Message-ID: <CACRpkdZ_TgS2XFHyEhkWTHsgdv-Yw2jj9342nDihiJjjGPh7Bw@mail.gmail.com>
Subject: Re: [PATCH 0/3] pinctrl: qcom: Add IPQ8064 pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Gross <agross@codeaurora.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 5:10 AM, Andy Gross <agross@codeaurora.org> wrote:

> This set of patches adds pinctrl support for the Qualcomm IPQ8064 platform.
> The IPQ8064 uses the same TLMM block as the APQ8064, but has a different number
> of pins, functions, and function assignments.  The second patch contains the
> devicetree documentation.  The last patch selects PINCTRL for all ARCH_QCOM
> platforms.  This allows for selection of pinctrl support via a make menuconfig.
>
> Andy Gross (3):
>   pinctrl: qcom: Add definitions for IPQ8064
>   dt: Document Qualcomm IPQ8064 pinctrl binding
>   ARM: qcom: Select PINCTRL by default for ARCH_QCOM

Björn can you look at this series?

David/Bryan: can either of you ACK the changes hitting
arch/arm/mach-qcom/Kconfig
so I can merge this through the pinctrl tree?

Yours,
Linus Walleij
