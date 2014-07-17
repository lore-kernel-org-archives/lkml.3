Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaGQIlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:41:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41128 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbaGQIlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:41:50 -0400
Message-ID: <53C78C31.7000709@ti.com>
Date: Thu, 17 Jul 2014 14:11:21 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <bhelgaas@google.com>,
        <mohit.kumar@st.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>
Subject: Re: [PATCH v2 0/4] dra7: Add PCIe support
References: <1405349705-31400-1-git-send-email-kishon@ti.com> <009001cfa16b$0c558ea0$2500abe0$%han@samsung.com>
In-Reply-To: <009001cfa16b$0c558ea0$2500abe0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 17 July 2014 08:28 AM, Jingoo Han wrote:
> On Monday, July 14, 2014 11:55 PM, Kishon Vijay Abraham I wrote:
>>
>> Changes from v1:
>> * fixed dw_pcie_prog_viewport_io_outbound() to use untranslated address
>> * split dra7xx patch into driver part and documentation part
>>
>> [1] is split into separate series in order for individual subsystem
>> Maintainers to pick up the patches. This series handles the PCIe
>> support for DRA7.
>>
>> Rebased to pci -next.
>>
>> [1] -> https://lkml.org/lkml/2014/5/29/258
>>
>> Kishon Vijay Abraham I (4):
>>   PCI: designware: Configuration space should be specified in 'reg'
>>   PCI: designware: use untranslated address while programming ATU
>>   Documentation: pci: ti: Add dt binding documentation for PCIe in
>>     DRA7xx
>>   PCI: host: pcie-dra7xx: add support for pcie-dra7xx controller
> 
> Kishon,
> 
> Actually, I have no objections to these patches.

Thanks :-)
> Then, how about adding maintainer entry for pci-dra7xx.c
> to MAINTAINERS file? It would be good. :-)

Sure, will post it.

-Kishon
