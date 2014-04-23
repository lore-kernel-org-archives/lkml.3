Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaDWO1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:27:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32922 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaDWO06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:26:58 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 3/3] ARM: qcom: Select PINCTRL by default for ARCH_QCOM
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CACRpkdauApm8_3DGE3Q4k-xkEpcrb2nUn=UhS+xHnVn4t+g2CA@mail.gmail.com>
Date: Wed, 23 Apr 2014 09:26:54 -0500
Cc: Andy Gross <agross@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0B526586-54FE-45E7-BA23-C405AD39FABA@codeaurora.org>
References: <1397531437-9104-1-git-send-email-agross@codeaurora.org> <1397531437-9104-4-git-send-email-agross@codeaurora.org> <CACRpkdauApm8_3DGE3Q4k-xkEpcrb2nUn=UhS+xHnVn4t+g2CA@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 23, 2014, at 9:03 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

> On Tue, Apr 15, 2014 at 5:10 AM, Andy Gross <agross@codeaurora.org> wrote:
> 
>> Add missing PINCTRL selection.  This enables selection of pinctrollers for
>> Qualcomm processors.
>> 
>> Signed-off-by: Andy Gross <agross@codeaurora.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> David are you picking this to the Qualcomm tree?

I’ll pick it up

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

