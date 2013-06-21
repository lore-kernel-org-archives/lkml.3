Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422995Ab3FUOea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:34:30 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64814 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369Ab3FUOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <51C2428C.4070102@ti.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
	<1371451599-31035-22-git-send-email-amit.daniel@samsung.com>
	<51C2428C.4070102@ti.com>
Date: Fri, 21 Jun 2013 20:04:28 +0530
X-Google-Sender-Auth: l7DKbqWLb6sCSgZpM8fYv3WbsPc
Message-ID: <CADGdYn7=kRpdZfhZR4Hg6kdaEG9yQL=HMX7QOTBTfMh30NqKqg@mail.gmail.com>
Subject: Re: [PATCH V6 21/30] ARM: dts: thermal: exynos4: Add documentation
 for Exynos SoC thermal bindings
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, jonghwa3.lee@samsung.com,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 5:15 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>> From: Lukasz Majewski <l.majewski@samsung.com>
>>
>> Proper description for Exynos4 bindings added to Documentation/devicetree/
>> bindings
>>
>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  .../devicetree/bindings/thermal/exynos-thermal.txt |   25 ++++++++++++++++++++
>>  1 files changed, 25 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> new file mode 100644
>> index 0000000..535fd0e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> @@ -0,0 +1,25 @@
>> +* Exynos Thermal Management Unit (TMU)
>> +
>> +** Required properties:
>> +
>> +- compatible : One of the following:
>> +            "samsung,exynos4412-tmu"
>> +            "samsung,exynos4210-tmu"
>> +            "samsung,exynos5250-tmu"
>> +- interrupt-parent : The phandle for the interrupt controller
>> +- reg : Address range of the thermal registers
>> +- interrupts : Should contain interrupt for thermal system
>> +- clocks : The main clock for TMU device
>> +- clock-names : Thermal system clock name
>
> Should this include the documentation on the alias needed by patch 18?
> tmuctrl?
>Yes right it should be there. Actually It is there in the later patches. Will re-submit this patch in proper order.
>
>> +
>> +Example:
>> +
>> +     tmu@100C0000 {
>> +             compatible = "samsung,exynos4412-tmu";
>> +             interrupt-parent = <&combiner>;
>> +             reg = <0x100C0000 0x100>;
>> +             interrupts = <2 4>;
>> +             clocks = <&clock 383>;
>> +             clock-names = "tmu_apbif";
>> +             status = "disabled";
>> +     };
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
