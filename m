Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965806AbaKNT0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:26:08 -0500
Received: from exprod5og126.obsmtp.com ([64.18.0.251]:42636 "HELO
	exprod5og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965677AbaKNT0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:26:06 -0500
MIME-Version: 1.0
In-Reply-To: <1829495.FoDfH1G36W@wuerfel>
References: <1415924401-3013-1-git-send-email-fkan@apm.com>
	<1415924401-3013-5-git-send-email-fkan@apm.com>
	<1829495.FoDfH1G36W@wuerfel>
Date: Fri, 14 Nov 2014 11:26:04 -0800
Message-ID: <CAL85gmDYM2V=TCtA5iBazj+k6rfvpd6c2dnqaA2jfifyxeZR_w@mail.gmail.com>
Subject: Re: [PATCH V2 4/7] arm64: dts: Add Designware GPIO dts binding to APM
 X-Gene platform
From: Feng Kan <fkan@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 7:06 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 13 November 2014 16:19:58 Feng Kan wrote:
>> +               dwgpio: dwgpio@1c024000 {
>> +                       compatible = "snps,dw-apb-gpio";
>> +                       reg = <0x0 0x1c024000 0x0 0x1000>;
>> +                       reg-io-width = <4>;
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>>
>
> Same comment as patch 1: make the node name 'gpio', not 'dwgpio'.

I can make this change.
>
>         Arnd
