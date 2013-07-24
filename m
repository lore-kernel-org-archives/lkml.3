Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3GXQai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:30:38 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62201 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3GXQaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:30:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7TexM5-7Z=8H+B5=49-GzoKd_prn=LbMFZWV9rpdn__A@mail.gmail.com>
References: <CAL-B5D03ki8NHsM6EuESTH2K-Eh+XyFHNXPDYwgDq+oagDjtMQ@mail.gmail.com>
	<CAErSpo7TexM5-7Z=8H+B5=49-GzoKd_prn=LbMFZWV9rpdn__A@mail.gmail.com>
Date: Wed, 24 Jul 2013 10:30:33 -0600
Message-ID: <CAKocOOOW6+eqb6GTsWLgonQQ7uy5R10t6L_T3jaTN9qSbetVeQ@mail.gmail.com>
Subject: Re: Linux Plumbers ACPI/PM, PCI Microconference
From: Shuah Khan <shuahkhan@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@gmail.com>, linux-pci <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        virtualization@lists.linux-foundation.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Jul 16, 2013 at 8:21 PM, Myron Stowe <myron.stowe@gmail.com> wrote:
>> Linux Plumbers has approved an ACPI/PM, PCI microconference. The
>> overview page is here:
>>
>> http://wiki.linuxplumbersconf.org/2013:pci_subsystem
>>
>> We would like to start receiving volunteers for presenting topics of
>> interest.  There is a lot of activity in these subsystems so please
>> respond by submitting presentation or discussion proposals that you
>> would be willing to cover for consideration.  You should also feel
>> free to submit ideas as proposals that others could cover.
>
> Somebody else privately suggested these ARM/PCI topics:
>
>> -> how it's been cleaned up to be more common across arm-32 machines
>> -> dependencies on dtb
>> -> future use/dependency(s) on ACPI
>> -> hotplug support issues (if any; acpi (host-bridge) vs <whatever ARM uses> ?)
>
> and I'm interested in those as well.  There seems to be a lot of
> activity in that area.  In addition, I'm interested in ARM IOMMU
> support.  I see drivers/iommu/arm-smmu.c, but it's brand-new and I
> haven't looked at it at all.
>

I second this topic. I am interested in ARM/iommu space also.

thanks,
-- Shuah
