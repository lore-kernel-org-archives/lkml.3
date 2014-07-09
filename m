Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaGIDul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:50:41 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38681 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaGIDuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:50:39 -0400
MIME-Version: 1.0
In-Reply-To: <53AA151E.9090701@suse.de>
References: <1403633766-25796-1-git-send-email-bjorn.andersson@sonymobile.com>
	<53AA151E.9090701@suse.de>
Date: Tue, 8 Jul 2014 20:50:38 -0700
Message-ID: <CAJAp7OieWraVQ35hDJ6HQ1ycSkZ1ShKvkkuuRxKUEmti5ethhA@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: msm: Add msm8960 definitions
From: Bjorn Andersson <bjorn@kryo.se>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 5:17 PM, Andreas Färber <afaerber@suse.de> wrote:
> Am 24.06.2014 20:16, schrieb Bjorn Andersson:
>> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
>> new file mode 100644
>> index 0000000..6e79eea
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
> [...]
>> +Example:
>> +
>> +     msmgpio: pinctrl@800000 {
>> +             compatible = "qcom,msm8960-pinctrl";
>> +             reg = <0x800000 0x4000>;
>> +
>> +             gpio-controller;
>> +             #gpio-cells = <2>;
>> +             interrupt-controller;
>> +             #interrupt-cells = <2>;
>> +                interrupts = <0 32 0x4>;
>
> This line seems space-indented while surrounding ones are tab-indented.
>

Thanks, not only is it incorrectly indented, it's also a bad example
as it's the wrong IRQ for msm8960...

>> +
>> +             pinctrl-names = "default";
>> +             pinctrl-0 = <&debug_uart>;
>> +
>> +             debug_uart: debug_uart {
>
> While at it, might debug-uart be a better node name? That seems the
> predominant convention and distinguishes from the label.
>

You're right and reference design does not use gsbi8 as uart, so I'll update it.

Thanks for the review.

Regards,
Bjorn
