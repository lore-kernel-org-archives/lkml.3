Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaE1Q71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:59:27 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43075 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaE1Q7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <F773CDFB-2957-49C0-99D3-E9CDCE33C378@codeaurora.org>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
	<F773CDFB-2957-49C0-99D3-E9CDCE33C378@codeaurora.org>
Date: Wed, 28 May 2014 09:59:23 -0700
Message-ID: <CAJAp7Ojb7PvuNYJkPyKx+iehi0bF6rdYvYmfrDz21mebxMN1qg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Qualcomm Resource Power Manager driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 9:23 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On May 27, 2014, at 12:28 PM, Bjorn Andersson <bjorn.andersson@sonymobile.com> wrote:
>
>> This series adds a regulator driver for the Resource Power Manager found in
>> Qualcomm 8660, 8960 and 8064 based devices.
>>
>> The RPM driver exposes resources to its child devices, that can be accessed to
>> implement drivers for the regulators, clocks and bus frequency control that's
>> owned by the RPM in these devices.
>
> Rather than adding yet another mfd driver, how about we put this in drivers/soc/qcom as a much better location for the low level rpm code.  Some code already merged in arm-soc for creation of drivers/soc/qcom/

Hi Kumar,

I do see rpm as somewhat equivalent to a pmic and that was why I
followed suite and put it in mfd, but I can of course move it if you
prefer.


Lately I've been working on rpm, rpm-smd, smem, smd, smsm, smp2p
patches for mainline.
It could be argued that smd is a bus and should go in drivers/bus, but
for the rest I fear that we just created drivers/soc/qcom as another
dumping ground for things; a "Qualcomm specific drivers/mfd".

But maybe that is the purpose of it ;)


If I move the rpm driver, are there any conclusion to where I should
move the dt binding documentation?

Regards,
Bjorn
