Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaE1ICP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:02:15 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63780 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbaE1ICM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:02:12 -0400
MIME-Version: 1.0
In-Reply-To: <5383C28D.1060808@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400849578-7585-1-git-send-email-srinivas.kandagatla@linaro.org>
	<CAPDyKFqz-O9-Douk96LBuFRD_P1146c_Ld14TgiduBgfBqRi_A@mail.gmail.com>
	<5383C28D.1060808@linaro.org>
Date: Wed, 28 May 2014 10:02:11 +0200
Message-ID: <CACRpkdYjQzwVF8ikqqt=7pCvdKM59JcM4HS-UNJ8Ueqdw9az4A@mail.gmail.com>
Subject: Re: [PATCH v3 12/13] mmc: mmci: add explicit clk control
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:39 AM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> On 26/05/14 15:21, Ulf Hansson wrote:
>> On 23 May 2014 14:52,  <srinivas.kandagatla@linaro.org> wrote:

>>>
>>> +       bool                    explicit_mclk_control;
>>> +       bool                    cclk_is_mclk;
>>
>> I can't see why you need to have both these new configurations. Aren't
>> "cclk_is_mclk" just a fact when you use "explicit_mclk_control".
>
>> I also believe I would prefer something like "qcom_clkdiv" instead.
>
> There is a subtle difference between both the flags.  Am happy to change it
> to qcom_clkdiv.

I think this was due to me wanting the variant variables to be more about
the actual technical difference they indicate rather than pointing to
a certain vendor or variant where that difference occurs.

It's a very minor thing though, if you prefer it this way, go for it.

Yours,
Linus Walleij
