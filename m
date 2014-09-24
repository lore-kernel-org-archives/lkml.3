Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaIXNbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:31:05 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:37037 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaIXNa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:30:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5PBXSUeU_LP2m=9jxibmqxreL4tEeHBsc5To7D=_bAJA@mail.gmail.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <20140923215435.GD27117@google.com> <20140923224810.GA32643@bart.dudau.co.uk> <CAErSpo5PBXSUeU_LP2m=9jxibmqxreL4tEeHBsc5To7D=_bAJA@mail.gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 24 Sep 2014 08:30:37 -0500
Message-ID: <CAL_Jsq+U=1JT0qqZgb=aR66Q4NYDyzOogspOmmpsp61pE+aCUg@mail.gmail.com>
Subject: Re: [PATCH v12 00/12] Support for creating generic PCI host bridges
 from DT
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <liviu@dudau.co.uk>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 6:00 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Sep 23, 2014 at 4:48 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
>> ...
>> While the next immediate target is converting pci-host-generic.c, pci-imx6.c
>> and probably pcie-designware.c to my series, I would like to ask you what
>> is your longer term plan. Now that I have got my head full of PCI code,
>> I have some ideas but feel that meeting with you and all those involved
>> in core PCI support would be a better venue than sending emails back and
>> forth. When is your next plan to attend a Linux conference?
>
> That would be nice.  Unfortunately, I don't know what the next
> conference will be yet.

Perhaps an irc meeting or Google hangout. These have been happening on
several areas like DT and ARM KVM.

Rob
