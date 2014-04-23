Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaDWOD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:03:28 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:43164 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbaDWODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <1397531437-9104-4-git-send-email-agross@codeaurora.org>
References: <1397531437-9104-1-git-send-email-agross@codeaurora.org>
	<1397531437-9104-4-git-send-email-agross@codeaurora.org>
Date: Wed, 23 Apr 2014 16:03:23 +0200
Message-ID: <CACRpkdauApm8_3DGE3Q4k-xkEpcrb2nUn=UhS+xHnVn4t+g2CA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: qcom: Select PINCTRL by default for ARCH_QCOM
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Gross <agross@codeaurora.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 5:10 AM, Andy Gross <agross@codeaurora.org> wrote:

> Add missing PINCTRL selection.  This enables selection of pinctrollers for
> Qualcomm processors.
>
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

David are you picking this to the Qualcomm tree?

Yours,
Linus Walleij
