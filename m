Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbbAHWre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:47:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49945 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757678AbbAHWrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:47:31 -0500
Message-ID: <54AF08DC.3000302@ti.com>
Date: Thu, 8 Jan 2015 17:46:52 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v3 3/4] of/pci: add of_pci_dma_configure() update dma
 configuration
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <20150108160626.GN11583@arm.com> <54AEDFED.8060008@ti.com> <2057344.eJYxBNosJg@wuerfel>
In-Reply-To: <2057344.eJYxBNosJg@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 05:25 PM, Arnd Bergmann wrote:
> On Thursday 08 January 2015 14:52:13 Murali Karicheri wrote:
>>
>> Could you add this as as a follow up patch as I don't have a platformm
>> that support IOMMU and as such my understanding of the IOMMU is limited?
>>
>> I can help test the change to make sure it has no side effect on
>> Keystone that doesn't support IOMMU.
>
> I think that's fine. Let's get your series done first and add the
> DMA aliases for iommus on top once we have worked out what to do.
>
> 	Arnd
Ok.

-- 
Murali Karicheri
Linux Kernel, Texas Instruments
