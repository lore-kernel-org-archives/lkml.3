Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966325Ab3DRNpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:45:44 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:32936 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965366Ab3DRNpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:45:40 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] of/pci: mips: convert to common of_pci_range_parser
To: Andrew Murray <Andrew.Murray@arm.com>, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org
Cc: rob.herring@calxeda.com, jgunthorpe@obsidianresearch.com,
        linux@arm.linux.org.uk, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        jg1.han@samsung.com, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        bhelgaas@google.com, suren.reddy@samsung.com,
        linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        benh@kernel.crashing.org, paulus@samba.org,
        thomas.petazzoni@free-electrons.com, thierry.reding@avionic-design.de,
        thomas.abraham@linaro.org, arnd@arndb.de, linus.walleij@linaro.org,
        Andrew Murray <Andrew.Murray@arm.com>
In-Reply-To: <1366107508-12672-4-git-send-email-Andrew.Murray@arm.com>
References: <1366107508-12672-1-git-send-email-Andrew.Murray@arm.com> <1366107508-12672-4-git-send-email-Andrew.Murray@arm.com>
Date: Thu, 18 Apr 2013 14:45:35 +0100
Message-Id: <20130418134535.5189E3E1319@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013 11:18:28 +0100, Andrew Murray <Andrew.Murray@arm.com> wrote:
> This patch converts the pci_load_of_ranges function to use the new common
> of_pci_range_parser.
> 
> Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Reviewed-by: Rob Herring <rob.herring@calxeda.com>

Looks okay to me, and thank you very much for doing the legwork to merge
the common code.

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

