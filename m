Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbbAHWZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:25:55 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:50867 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbbAHWZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:25:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v3 3/4] of/pci: add of_pci_dma_configure() update dma configuration
Date: Thu, 08 Jan 2015 23:25:15 +0100
Message-ID: <2057344.eJYxBNosJg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54AEDFED.8060008@ti.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <20150108160626.GN11583@arm.com> <54AEDFED.8060008@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:MN3NLWUlCffhyl7G1/I4qY2q6cpZyov87Vh2lB28F0aBWwFiAdm
 tfOs+1/A5wIBUkYIYRGATaQnf22byoSuB4jRB0uhx8L8vTgIy13Eweb2/bjZTU8wdNHOI5y
 DgiKpRQHttfEq60xKGnUdXi1SwkomrVrVuRojnW750I8KglwbCKicKgHSag2KYsobVF0gVk
 +urM9P5lTD4hOax48Yegg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 14:52:13 Murali Karicheri wrote:
> 
> Could you add this as as a follow up patch as I don't have a platformm 
> that support IOMMU and as such my understanding of the IOMMU is limited?
> 
> I can help test the change to make sure it has no side effect on 
> Keystone that doesn't support IOMMU.

I think that's fine. Let's get your series done first and add the
DMA aliases for iommus on top once we have worked out what to do.

	Arnd
