Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaI3JLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:11:39 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56240 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaI3JLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqK2bqsbjEf2OngL2=Xr8t0AUobb_bd43BV4t9iXY-n6KQ@mail.gmail.com>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
	<1411573068-12952-4-git-send-email-rric@kernel.org>
	<3082935.e3X4GsVUDn@wuerfel>
	<CAL_JsqK2bqsbjEf2OngL2=Xr8t0AUobb_bd43BV4t9iXY-n6KQ@mail.gmail.com>
Date: Tue, 30 Sep 2014 14:41:35 +0530
Message-ID: <CA+sq2Cc3isZThykhCU=nzFx0BYFvmv+qCTHTuE48bjN+FdVjfA@mail.gmail.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
From: Sunil Kovvuri <sunil.kovvuri@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        Sunil Goutham <sgoutham@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for pointing correction ROB.
Will fix it.

On Fri, Sep 26, 2014 at 11:56 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Sep 24, 2014 at 11:06 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wednesday 24 September 2014 17:37:45 Robert Richter wrote:
>>>
>>> +       pcie0@0x8480,00000000 {
>>
>> The name should be pci, not pci0.
>
> And the address should be "@848000000000". There was some confusion
> about when the comma should be used and it is only if you have things
> like PCI bus, device, function for the addressing.
>
>
>>
>>> +               compatible = "cavium,thunder-pcie";
>
> A bit too generic as many of the Cavium bindings have been.
>
> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
