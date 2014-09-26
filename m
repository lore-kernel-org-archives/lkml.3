Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaIZS0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:26:35 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:57780 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbaIZS0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:26:33 -0400
MIME-Version: 1.0
In-Reply-To: <3082935.e3X4GsVUDn@wuerfel>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <1411573068-12952-4-git-send-email-rric@kernel.org> <3082935.e3X4GsVUDn@wuerfel>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 26 Sep 2014 13:26:09 -0500
Message-ID: <CAL_JsqK2bqsbjEf2OngL2=Xr8t0AUobb_bd43BV4t9iXY-n6KQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
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

On Wed, Sep 24, 2014 at 11:06 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 24 September 2014 17:37:45 Robert Richter wrote:
>>
>> +       pcie0@0x8480,00000000 {
>
> The name should be pci, not pci0.

And the address should be "@848000000000". There was some confusion
about when the comma should be used and it is only if you have things
like PCI bus, device, function for the addressing.


>
>> +               compatible = "cavium,thunder-pcie";

A bit too generic as many of the Cavium bindings have been.

Rob
