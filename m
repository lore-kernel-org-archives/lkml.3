Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbaCRVrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:47:40 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:49230 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274AbaCRVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140318211806.GG5917@mithrandir>
References: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
	<1394655346-30048-2-git-send-email-tim.kryger@linaro.org>
	<20140318211806.GG5917@mithrandir>
Date: Tue, 18 Mar 2014 14:47:36 -0700
Message-ID: <CAAYSxhq5gdK9b50GuWqsVBmW0H+KjcRutkWK026WjP5b1HkiDA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] Documentation: dt: Add Kona PWM binding
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 2:18 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Wed, Mar 12, 2014 at 01:15:42PM -0700, Tim Kryger wrote:

>> @@ -0,0 +1,24 @@
>> +Broadcom Kona PWM controller device tree bindings
>> +
>> +This controller has 6 channels.
>> +
>> +Required Properties :
>> +- compatible: should be "brcm,kona-pwm"
>
> This is somewhat inconsistent because the example below clearly doesn't
> set the compatible property to "brcm,kona-pwm". Perhaps better wording
> would be:
>
>         - compatible: should contain "brcm,kona-pwm"

Agreed, what you wrote is more accurate.  I will update it.

>> +- reg: physical base address and length of the controller's registers
>> +- clocks: phandle + clock specifier pair for the external clock
>> +- #pwm-cells: should be 3.  The first cell specifies the per-chip index
>> +  of the PWM to use, the second cell is the period in nanoseconds, and
>> +  the third cell is the flags.
>
> Please use the canonical description for this:
>
>         - #pwm-cells: Should be 3. See pwm.txt in this directory for a
>           description of the cells format.
>
>> +Refer to pwm/pwm.txt for generic pwm controller node properties.
>
> With the above, this line should go away. But still: "pwm controller" ->
> "PWM controller".

Okay.  I will use the text you provided and drop the other line.

Sorry for missing the capitalization.  I thought I had fixed them all.

Thanks,
Tim
