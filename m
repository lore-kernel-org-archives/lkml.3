Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaEOOvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:51:11 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:64267 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaEOOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140422131309.9E6E1C40754@trevor.secretlab.ca>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <1397756521-29387-3-git-send-email-leif.lindholm@linaro.org> <20140422131309.9E6E1C40754@trevor.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 15 May 2014 15:50:48 +0100
X-Google-Sender-Auth: dezU_rShc-vQyp0IQrY7aaIoESU
Message-ID: <CACxGe6suKO5n0fg8dHGSwi0Esjbu6dyYdJPLH0AScKsDCABKbg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mips: dts: add device_type="memory" where missing
To: Leif Lindholm <leif.lindholm@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "patches@linaro.org" <patches@linaro.org>,
        linux-mips <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        John Crispin <blogic@openwrt.org>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 2:13 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, 17 Apr 2014 18:42:00 +0100, Leif Lindholm <leif.lindholm@linaro.org> wrote:
>> A few platforms lack a 'device_type = "memory"' for their memory
>> nodes, relying on an old ppc quirk in order to discover its memory.
>> Add this, to permit that quirk to be made ppc only.
>>
>> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
>> Cc: linux-mips@linux-mips.org
>> Cc: devicetree@vger.kernel.org
>> Cc: John Crispin <blogic@openwrt.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>
> Acked-by: Grant Likely <grant.likely@linaro.org>

Applied, thanks.

g.

>
>> ---
>>  arch/mips/lantiq/dts/easy50712.dts    |    1 +
>>  arch/mips/ralink/dts/mt7620a_eval.dts |    1 +
>>  arch/mips/ralink/dts/rt2880_eval.dts  |    1 +
>>  arch/mips/ralink/dts/rt3052_eval.dts  |    1 +
>>  arch/mips/ralink/dts/rt3883_eval.dts  |    1 +
>>  5 files changed, 5 insertions(+)
>>
>> diff --git a/arch/mips/lantiq/dts/easy50712.dts b/arch/mips/lantiq/dts/easy50712.dts
>> index fac1f5b..143b8a3 100644
>> --- a/arch/mips/lantiq/dts/easy50712.dts
>> +++ b/arch/mips/lantiq/dts/easy50712.dts
>> @@ -8,6 +8,7 @@
>>       };
>>
>>       memory@0 {
>> +             device_type = "memory";
>>               reg = <0x0 0x2000000>;
>>       };
>>
>> diff --git a/arch/mips/ralink/dts/mt7620a_eval.dts b/arch/mips/ralink/dts/mt7620a_eval.dts
>> index 35eb874..709f581 100644
>> --- a/arch/mips/ralink/dts/mt7620a_eval.dts
>> +++ b/arch/mips/ralink/dts/mt7620a_eval.dts
>> @@ -7,6 +7,7 @@
>>       model = "Ralink MT7620A evaluation board";
>>
>>       memory@0 {
>> +             device_type = "memory";
>>               reg = <0x0 0x2000000>;
>>       };
>>
>> diff --git a/arch/mips/ralink/dts/rt2880_eval.dts b/arch/mips/ralink/dts/rt2880_eval.dts
>> index 322d700..0a685db 100644
>> --- a/arch/mips/ralink/dts/rt2880_eval.dts
>> +++ b/arch/mips/ralink/dts/rt2880_eval.dts
>> @@ -7,6 +7,7 @@
>>       model = "Ralink RT2880 evaluation board";
>>
>>       memory@0 {
>> +             device_type = "memory";
>>               reg = <0x8000000 0x2000000>;
>>       };
>>
>> diff --git a/arch/mips/ralink/dts/rt3052_eval.dts b/arch/mips/ralink/dts/rt3052_eval.dts
>> index 0ac73ea..ec9e9a0 100644
>> --- a/arch/mips/ralink/dts/rt3052_eval.dts
>> +++ b/arch/mips/ralink/dts/rt3052_eval.dts
>> @@ -7,6 +7,7 @@
>>       model = "Ralink RT3052 evaluation board";
>>
>>       memory@0 {
>> +             device_type = "memory";
>>               reg = <0x0 0x2000000>;
>>       };
>>
>> diff --git a/arch/mips/ralink/dts/rt3883_eval.dts b/arch/mips/ralink/dts/rt3883_eval.dts
>> index 2fa6b33..e8df21a 100644
>> --- a/arch/mips/ralink/dts/rt3883_eval.dts
>> +++ b/arch/mips/ralink/dts/rt3883_eval.dts
>> @@ -7,6 +7,7 @@
>>       model = "Ralink RT3883 evaluation board";
>>
>>       memory@0 {
>> +             device_type = "memory";
>>               reg = <0x0 0x2000000>;
>>       };
>>
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
