Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbaITCO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 22:14:56 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63046 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaITCOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 22:14:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v11 03/10] ARM: Define PCI_IOBASE as the base of virtual PCI IO space.
Date: Sat, 20 Sep 2014 04:14:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        "linux-arch" <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com> <1411003825-21521-4-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1411003825-21521-4-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409200414.10675.arnd@arndb.de>
X-Provags-ID: V02:K0:Au6XCADHLEGm4BHf+k8aQK3bw9hg3a33+PzbrkK++lm
 /+ubMrCStmY5daj+BEfuJibLxTGmajFN374xKXASHiPQbPosgt
 fP0gL67mxS60YEm/1QKqGqv8A7Q8AJpNgOtemyDgg8kXUgTcD3
 98jErc6nLU5t2Zq/8qGxh92kf1AvmVHsgimJw5/yAvzVSkFioj
 4ik5WozIR+ySHxXhPpCU1eqqmdOHZ32HtENA95ONcU5snejZwc
 7CF+vvBsnNalqkgkCjEKjj1hoW7XM9IfN2UvkcHRjCmMXjAlBf
 n6OqV1COBUmO6YtAIRRWFPDQiFzsgCqDydyqjzXyAMPoWV1jS4
 tSlLFlnPuvdAOJ80gVfw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2014, Liviu Dudau wrote:
> This is needed for calls into OF code that parses PCI ranges.
> It signals support for memory mapped PCI I/O accesses that
> are described be device trees.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
