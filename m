Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935989Ab3DKQ5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:57:18 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:41164 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114Ab3DKQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:57:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130410233059.5cdcc119@skate>
References: <1365578969-30966-1-git-send-email-Andrew.Murray@arm.com>
	<1365578969-30966-2-git-send-email-Andrew.Murray@arm.com>
	<51656592.7070806@gmail.com>
	<20130410233059.5cdcc119@skate>
Date: Thu, 11 Apr 2013 18:57:12 +0200
Message-ID: <CACRpkdY1PNLp7guzazCUvLCs8OqTopm40wg6L0DAC+2+Eu91og@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] of/pci: Unify pci_process_bridge_OF_ranges from
 Microblaze and PowerPC
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robherring2@gmail.com>,
        Andrew Murray <Andrew.Murray@arm.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        siva.kallam@samsung.com, linux-pci@vger.kernel.org,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jingoo Han <jg1.han@samsung.com>, Liviu.Dudau@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Paul Mackerras <paulus@samba.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>, suren.reddy@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 11:30 PM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:

> Ben, Michal, could you review/test this patch from Andrew Murray? I
> need it as a dependency of "[PATCH v5 2/3] of/pci: Provide support for
> parsing PCI DT ranges property", which itself is used by the Marvell
> PCIe driver I'm hoping to get merged in 3.10.

Second this, I also have a patch series that depend on these patches.

Yours,
Linus Walleij
