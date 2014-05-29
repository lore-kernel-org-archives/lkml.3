Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaE2TFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:05:15 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:55248 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaE2TFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:05:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140529165437.GM1954@lee--X1>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com>
	<20140529165437.GM1954@lee--X1>
Date: Thu, 29 May 2014 12:05:10 -0700
Message-ID: <CAJAp7OgiGQMi16_UgB3KmMZAhw7m7+rUSqnk0UrAimoD8+09oQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
From: Bjorn Andersson <bjorn@kryo.se>
To: Lee Jones <lee.jones@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 9:54 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> diff --git a/include/dt-bindings/mfd/qcom_rpm.h b/include/dt-bindings/mfd/qcom_rpm.h
>> new file mode 100644
>> index 0000000..277e789
>> --- /dev/null
>> +++ b/include/dt-bindings/mfd/qcom_rpm.h
>> @@ -0,0 +1,142 @@
>> +/*
>> + * This header provides constants for the Qualcomm RPM bindings.
>> + */
>
> Proper header please.

Will do.

>
>> +#ifndef _DT_BINDINGS_MFD_QCOM_RPM_H
>> +#define _DT_BINDINGS_MFD_QCOM_RPM_H
>> +
>> +#define QCOM_RPM_APPS_FABRIC_ARB             1
>> +#define QCOM_RPM_APPS_FABRIC_CLK             2
>> +#define QCOM_RPM_APPS_FABRIC_HALT            3
>
> [...]
>
>> +#define QCOM_RPM_SYS_FABRIC_MODE             131
>> +#define QCOM_RPM_USB_OTG_SWITCH              132
>> +#define QCOM_RPM_VDDMIN_GPIO                 133
>
> Are you sure you don't want these in 0xXY format?

This is just a list of virtual identifiers, so unless you object to
much I'll leave them in base 10.

Thanks,
Bjorn
