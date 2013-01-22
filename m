Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3AVWT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:19:59 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57081 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3AVWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:19:57 -0500
MIME-Version: 1.0
In-Reply-To: <2072996.JYmST9orI6@vostro.rjw.lan>
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
	<2072996.JYmST9orI6@vostro.rjw.lan>
Date: Tue, 22 Jan 2013 14:19:56 -0800
X-Google-Sender-Auth: SRQ_aMb8ocNVC_NukChBZuskPo4
Message-ID: <CAE9FiQUS56KnvDCF7LUyCkNLcun+3zZ+xGiexca2ej30dRvrQg@mail.gmail.com>
Subject: Re: [PATCH v10 00/11] PCI, ACPI: pci root bus hotplug support / pci match_driver
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 2:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, January 21, 2013 01:20:41 PM Yinghai Lu wrote:
>> It includes
>> 1. preparing patches for pci root bus hotadd/hotremove support
>> 2. move root bus hotadd from acpiphp to pci_root.c
>> 3. add hot-remove support
>> 4. add acpi_hp_work to be shared with acpiphp and root-bus hotplug
>> 5. add match_driver to add pci device to device tree early but
>>    not attach driver for hotplug path.
>>
>> based on pci/next + pm/acpi-scan
>>
>> could get from
>>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug
>>
>> -v9: merges several patches together for easy review, requested by Rafael.
>> -v10: address comments from Rafael.
>>
>> Jiang Liu (2):
>>   PCI: Fix a device reference count leakage issue in pci_dev_present()
>>   PCI: make PCI device create/destroy logic symmetric
>>
>> Tang Chen (1):
>>   PCI, ACPI: debug print for installation of acpi root bridge's
>>     notifier
>>
>> Yinghai Lu (8):
>>   PCI, acpiphp: Add is_hotplug_bridge detection
>>   PCI: Add root bus children dev's res to fail list
>>   PCI: Set dev_node early for pci_dev
>>   PCI, ACPI, acpiphp: Rename alloc_acpiphp_hp_work() to alloc_acpi_hp_work
>>   PCI, acpiphp: Move and enhance hotplug support of pci host bridge
>>   PCI, acpiphp: Don't bailout even no slots found yet.
>>   PCI: Skip attaching driver in device_add()
>>   PCI: Put pci dev to device tree as early as possible
>
> OK
>
> Please feel free to add
>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> to all of the patches in this series I haven't acked already.

Thanks a lot for reviewing.
