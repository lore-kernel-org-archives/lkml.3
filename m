Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbaDVPfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:35:07 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49055 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbaDVPfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:35:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ_TgS2XFHyEhkWTHsgdv-Yw2jj9342nDihiJjjGPh7Bw@mail.gmail.com>
References: <1397531437-9104-1-git-send-email-agross@codeaurora.org>
	<CACRpkdZ_TgS2XFHyEhkWTHsgdv-Yw2jj9342nDihiJjjGPh7Bw@mail.gmail.com>
Date: Tue, 22 Apr 2014 08:35:02 -0700
Message-ID: <CAJAp7Ojhmz4tNyrPNCB7QYM=pXKOq+cqo0x_ozCAJfUA6FU9cg@mail.gmail.com>
Subject: Re: [PATCH 0/3] pinctrl: qcom: Add IPQ8064 pinctrl support
From: Bjorn Andersson <bjorn@kryo.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andy Gross <agross@codeaurora.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 8:11 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Apr 15, 2014 at 5:10 AM, Andy Gross <agross@codeaurora.org> wrote:
>
>> This set of patches adds pinctrl support for the Qualcomm IPQ8064 platform.
>> The IPQ8064 uses the same TLMM block as the APQ8064, but has a different number
>> of pins, functions, and function assignments.  The second patch contains the
>> devicetree documentation.  The last patch selects PINCTRL for all ARCH_QCOM
>> platforms.  This allows for selection of pinctrl support via a make menuconfig.
>>
>> Andy Gross (3):
>>   pinctrl: qcom: Add definitions for IPQ8064
>>   dt: Document Qualcomm IPQ8064 pinctrl binding
>>   ARM: qcom: Select PINCTRL by default for ARCH_QCOM
>
> Björn can you look at this series?

I don't have access to documentation for this platform, but I think
the "code" looks sane.

I would however like to push for the sort order of the Makefile and
Kconfig to be corrected (IPQ should come after APQ). Maybe you could
do that while picking the patches up?

With that change I find this

Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

>
> David/Bryan: can either of you ACK the changes hitting
> arch/arm/mach-qcom/Kconfig
> so I can merge this through the pinctrl tree?

Maintainer for qcom-soc is Kumar, I added him to the To list.
May I suggest that Kumar picks the last change in the series (addition
of PINCTRL), as it is unrelated to the rest of the series?

>
> Yours,
> Linus Walleij

Regards,
Bjorn
