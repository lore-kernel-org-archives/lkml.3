Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaCNRjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:39:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:59379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaCNRi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:38:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Date: Fri, 14 Mar 2014 18:38:08 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com> <1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com> <20140314171457.GK18126@arm.com>
In-Reply-To: <20140314171457.GK18126@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403141838.08900.arnd@arndb.de>
X-Provags-ID: V02:K0:6lyxJDAQQR6megD4pKUSMVk29pBFQAJcNuaer8Y3qkf
 ZcJiFqMYzqp4J4lsypvseNJ/y9yHhw64lMP7mVHYXwuSmVRGM5
 RWYKbpVWYfeVid/8o535sRmcpEQ1BOeynG4M7qKD5joTEGntbv
 P85AI8/QgaTf8EcFeRPqwEZ7RuODLo2E3kWRtqp4OQeEjATFsm
 imTtRt43YhRtUpqykoyInD2aHKqOJFlluw3FSqsVA2YHASqCg9
 48js2iy1zFSE+9GnzMwiohhDN0rDstPpt+J6jnC1iu51RXSP04
 4H0vFtrkFe1wnq+rhMIJ395yNcn8SAVAqQa5eXbnjHZFyspP25
 JbbwOgKPRRH4CFQ5NFCYaoVo1JEKgrt8E3Spp0jPd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 March 2014, Catalin Marinas wrote:
> On Fri, Mar 14, 2014 at 03:34:18PM +0000, Liviu Dudau wrote:
> > --- /dev/null
> > +++ b/arch/arm64/kernel/pci.c
> [...]
> > +int pci_register_io_range(phys_addr_t address, resource_size_t size)
> [...]
> > +unsigned long pci_address_to_pio(phys_addr_t address)
> [...]
> > +void pcibios_fixup_bus(struct pci_bus *bus)
> [ actually most of this file ]
> 
> Maybe it was raised before already but can we have __weak generic
> definitions of these functions? They don't seem to be arm64 specific in
> any way.
> 

I would definitely prefer that.

	Arnd
