Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbaGWP2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:28:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58213 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091AbaGWP2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:28:21 -0400
Message-ID: <53CFD444.4010700@ti.com>
Date: Wed, 23 Jul 2014 11:27:00 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 0/5] Add Keystone PCIe controller driver
References: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com> <20140722225708.GB27965@google.com>
In-Reply-To: <20140722225708.GB27965@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bjorn,

On 07/22/2014 06:57 PM, Bjorn Helgaas wrote:
> On Mon, Jul 21, 2014 at 12:58:40PM -0400, Murali Karicheri wrote:

>> Murali Karicheri (5):
>>    PCI: designware: add rd[wr]_other_conf API
>>    PCI: designware: refactor MSI code to work with v3.65 dw hardware
>
> I applied the above two to my pci/host-designware branch.  The rest didn't
> apply cleanly because I applied Kishon's DRA7xx changes first, and there
> are several conflicts.  Can you rebase the rest of them on top of
> pci/host-designware?

Thanks for applying 1 and 2.

I will fix up 3 based on your branch and send you updated patch 3 and 4 
today.  Hope you can apply this updated patch so that I don't have to 
address any rebase issues. Regarding the MRSS comment, I will discuss it 
on that thread and send you a fix for removing the bootargs depedency 
based on what comes out of that discussion. Is that fine?

Regards,

Murali

>
>>    PCI: designware: enhance dw_pcie_host_init() to support v3.65 DW
>>      hardware
>>    PCI: add PCI controller for keystone PCIe h/w
>>    PCI: keystone: Update maintainer information
>
> You can squash the MAINTAINERS update into the driver addition.  They're
> logically part of the same change.
>
> Bjorn
>
>>   .../devicetree/bindings/pci/pci-keystone.txt       |   68 +++
>>   MAINTAINERS                                        |    7 +
>>   drivers/pci/host/Kconfig                           |    5 +
>>   drivers/pci/host/Makefile                          |    1 +
>>   drivers/pci/host/pci-keystone-dw.c                 |  521 ++++++++++++++++++++
>>   drivers/pci/host/pci-keystone.c                    |  386 +++++++++++++++
>>   drivers/pci/host/pci-keystone.h                    |   58 +++
>>   drivers/pci/host/pcie-designware.c                 |  116 +++--
>>   drivers/pci/host/pcie-designware.h                 |    9 +
>>   9 files changed, 1135 insertions(+), 36 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
>>   create mode 100644 drivers/pci/host/pci-keystone-dw.c
>>   create mode 100644 drivers/pci/host/pci-keystone.c
>>   create mode 100644 drivers/pci/host/pci-keystone.h
>>
>> --
>> 1.7.9.5
>>

