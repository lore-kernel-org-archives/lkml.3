Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbaDIRpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:45:09 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:44199 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721AbaDIRpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:45:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140409110339.GF6529@pd.tnic>
References: <1220b715-6fc2-42ed-8393-b9859fc0deb9@TX2EHSMHS021.ehs.local>
	<20140408204047.GQ30077@pd.tnic>
	<CAGnW=BYJxEkhAitCGi-i6+260-i-+GPrg0yPcY=M+7YmDF6ZRw@mail.gmail.com>
	<20140409110339.GF6529@pd.tnic>
Date: Wed, 9 Apr 2014 23:15:00 +0530
X-Google-Sender-Auth: LpTo0UedWYpI4RIMlmPdnwSo8Vs
Message-ID: <CAGnW=BYay7fDeqgUDM4L8WqjEm66f5HVjht+RtbL+SPGOR1Xag@mail.gmail.com>
Subject: Re: [RFC PATCH v2] edac: synopsys: Added EDAC support for zynq ddr
 ecc controller
From: punnaiah choudary kalluri <punnaia@xilinx.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        dougthompson@xmission.com, linux-edac@vger.kernel.org,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        sorenb@xilinx.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punnaiah Choudary <kpc528@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 4:33 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Apr 09, 2014 at 11:34:31AM +0530, punnaiah choudary kalluri wrote:
>> Since it is recommended in Documentation/kernel-doc-nano-HOWTO.txt
>> but also said it is low priority and at the discretion of the MAINTAINER of
>> that kernel source file
>>
>> So, if you recommend not use kernel-doc annotation then i will take care
>> in next version.
>
> I don't think there's need for documenting those functions for
> kernel-doc - it is an EDAC driver and not some subsystem function with a
> lot of users.

OK. I just checked at highbank_mc_edac and other drivers found no documentation
for static functions. So, is it ok if i remove documentation
completely for these static
functions ?

Thanks,
Punnaiah
>
>> devm_ioremap_resource function will check this condition, so not
>> checking for the NULL explicitly
>
> And it would say
>
>         dev_err(dev, "invalid resource\n");
>
> so we'll know what fails, ok.
>
>> Since the probe returns error, it it that the devm_ framework will
>> clean these resources automatically?
>
> Ah, that's the managed thing, ok.
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
