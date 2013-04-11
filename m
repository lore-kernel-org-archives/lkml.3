Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912Ab3DKQz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:55:29 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:62536 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3DKQz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
References: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
Date: Thu, 11 Apr 2013 18:55:26 +0200
Message-ID: <CACRpkda_LxhoS5eciuC7F3_zmfYLyNO2fALi=ABeqGJDpSpKWw@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] of/pci: Provide common support for PCI DT parsing
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        siva.kallam@samsung.com, linux-pci@vger.kernel.org,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jingoo Han <jg1.han@samsung.com>, Liviu.Dudau@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>, suren.reddy@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 5:26 PM, Andrew Murray <Andrew.Murray@arm.com> wrote:

> This patchset factors out duplicated code associated with parsing PCI
> DT "ranges" properties across the architectures and introduces a
> "ranges" parser. This parser "of_pci_range_parser" can be used directly
> by ARM host bridge drivers enabling them to obtain ranges from device
> trees.
>
> I've included the Reviewed-by and Tested-by's received from v5 in this
> patchset, earlier versions of this patchset (v3) have been tested-by:
>
> Thierry Reding <thierry.reding@avionic-design.de>
> Jingoo Han <jg1.han@samsung.com>
>
> I believe a version of this patchset has also been tested through its
> inclusion in Thomas Petazzoni's Armada 370 and Armada XP SoCs PCIe support by:
>
> Linus Walleij <linus.walleij@linaro.org>

Yes you can add my Tested-by tag.

Yours,
Linus Walleij
