Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaJNMij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:38:39 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34111 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbaJNMih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <543CE22A.1080605@samsung.com>
References: <1413274468-8765-1-git-send-email-thomas.ab@samsung.com>
	<1413274468-8765-2-git-send-email-thomas.ab@samsung.com>
	<543CE22A.1080605@samsung.com>
Date: Tue, 14 Oct 2014 18:08:36 +0530
Message-ID: <CAJuA9agvSnehoCE=QoM2gDOiZKr2v3FcwCrEbDkbEBSug5V9Og@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: mfd: s2mps11: add documentation for
 s2mps15 PMIC
From: Thomas Abraham <ta.omasab@gmail.com>
To: =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski@samsung.com>
Cc: lee.jones@linaro.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 2:13 PM, Krzysztof Kozłowski
<k.kozlowski@samsung.com> wrote:
> On 14.10.2014 10:14, Thomas Abraham wrote:
>> Add dt-binding documentation for s2mps15 PMIC device. The s2mps15 device
>> is similar to s2mps11/14 PMIC device and has 27 LDO and 10 buck regulators.
>>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
>> ---
>>  Documentation/devicetree/bindings/mfd/s2mps11.txt |   11 ++++++++---
>>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> Looks good.
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>
> P.S. Wrong devicetree-discuss@lists.ozlabs.org list? I receive bounces.

Yes, that was wrong. Thanks for correcting it.

Regards,
Thomas.

>
> Best regards,
> Krzysztof
>
>
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
>> index 0e4026a..41ee3f5 100644
>> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
>> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
>> @@ -1,5 +1,5 @@
>>
>> -* Samsung S2MPS11, S2MPS14 and S2MPU02 Voltage and Current Regulator
>> +* Samsung S2MPS11/14/15 and S2MPU02 Voltage and Current Regulator
>>
>>  The Samsung S2MPS11 is a multi-function device which includes voltage and
>>  current regulators, RTC, charger controller and other sub-blocks. It is
>> @@ -7,8 +7,11 @@ interfaced to the host controller using an I2C interface. Each sub-block is
>>  addressed by the host system using different I2C slave addresses.
>>
>>  Required properties:
>> -- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic"
>> -              or "samsung,s2mpu02-pmic".
>> +- compatible: Should be one of the following
>> +     - "samsung,s2mps11-pmic"
>> +     - "samsung,s2mps14-pmic"
>> +     - "samsung,s2mps15-pmic"
>> +     - "samsung,s2mpu02-pmic"
>>  - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
>>
>>  Optional properties:
>> @@ -82,12 +85,14 @@ as per the datasheet of s2mps11.
>>                 - valid values for n are:
>>                       - S2MPS11: 1 to 38
>>                       - S2MPS14: 1 to 25
>> +                     - S2MPS15: 1 to 27
>>                       - S2MPU02: 1 to 28
>>                 - Example: LDO1, LDO2, LDO28
>>       - BUCKn
>>                 - valid values for n are:
>>                       - S2MPS11: 1 to 10
>>                       - S2MPS14: 1 to 5
>> +                     - S2MPS15: 1 to 10
>>                       - S2MPU02: 1 to 7
>>                 - Example: BUCK1, BUCK2, BUCK9
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
