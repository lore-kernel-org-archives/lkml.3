Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaCTKKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:10:36 -0400
Received: from 13.mo4.mail-out.ovh.net ([178.33.251.8]:38047 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752451AbaCTKKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:10:34 -0400
MIME-Version: 1.0
In-Reply-To: <532AB9EC.1030507@gmail.com>
References: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
	<1395173924-3648-10-git-send-email-b.brezillon.dev@gmail.com>
	<CACh+v5OF52ZuDBpkqpev1Jxv0DJ1ckRR+DjcX500i3o0o4HE9A@mail.gmail.com>
	<532AB9EC.1030507@gmail.com>
Date: Thu, 20 Mar 2014 11:09:53 +0100
Message-ID: <CACh+v5Psjgs=v2feP3oETXgxUXw6JsVDXBKhEG4OPCP1-YM1aQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] ARM: at91/dt: define main xtal frequency of the
 at91sam9261ek board
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris BREZILLON <brezillonboris@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 13723312491268167821
X-Ovh-Remote: 209.85.192.175 (mail-pd0-f175.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's right. I keep forgetting this.

2014-03-20 10:50 GMT+01:00 Boris BREZILLON <b.brezillon.dev@gmail.com>:
>
> Le 20/03/2014 10:24, Jean-Jacques Hiblot a écrit :
>
>> 2014-03-18 21:18 GMT+01:00 Boris BREZILLON <brezillonboris@gmail.com>:
>>>
>>> Define at91sam9261ek main crystal frequency.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>>> ---
>>>   arch/arm/boot/dts/at91sam9261ek.dts |    4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/at91sam9261ek.dts
>>> b/arch/arm/boot/dts/at91sam9261ek.dts
>>> index 2ce527e..7175986 100644
>>> --- a/arch/arm/boot/dts/at91sam9261ek.dts
>>> +++ b/arch/arm/boot/dts/at91sam9261ek.dts
>>> @@ -29,6 +29,10 @@
>>>                          compatible = "atmel,osc", "fixed-clock";
>>>                          clock-frequency = <18432000>;
>>>                  };
>>> +
>>> +               main_xtal: main_xtal {
>>> +                       clock-frequency = <18432000>;
>>> +               };
>>>          };
>>>
>>>          ahb {
>>> --
>>> 1.7.9.5
>>>
>> You forgot to remove the old fixed-clock definition for the main_clock:
>> clock@0
>
>
> We need this clock when CCF is disabled (when using the old at91 clk
> implementation).
> I'm afraid we'll have to keep it until we move all sam9 SoCs and boards to
> CCF (and DT).
>
> Best Regards,
>
> Boris
>
>>
>> Otherwise:
>> Acked-by: Jean-Jacques HIBLOT <jjhiblot@traphandler.com>
>
>
