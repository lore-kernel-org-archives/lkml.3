Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaA3OSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:18:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaA3OSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:18:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH V3 0/4] APM X-Gene PCIe controller
Date: Thu, 30 Jan 2014 15:17:51 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@apm.com, jcm@redhat.com
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com>
In-Reply-To: <1390599168-13150-1-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401301517.51352.arnd@arndb.de>
X-Provags-ID: V02:K0:dpMln3rP8JE4VChHZLnWsHYzgI31IvHuJXsIK9jPJ9p
 Jh5VGZnJufTt2T3vabqRobKSsncXU09zqs3PfqcdlAUorm2J2g
 ZM6UCrytlbrkriazhMGSuocdCAWlOonMVHS75WN3QFqmTOUrzo
 dcxsU8uXSq/FV7jysherHNFONWD2dZaX8QoeNJyOAfPDk1H5Nv
 DkiC7o0q857k4gpuZ03jK15i89H4YDFj3hNkDf77V4DAId7nrD
 e1ZENfOkhg98/CzYHGcxoEjHv11TroNZSLV5mFQAZqLQC76N4H
 nIz5RwBTcoJwdNuCtLrewR54AHWdVGtzSG/XcgDGf/b4j1iEL6
 z3rwOvWJ0O/22n+vj3JcgQ2vJtmnDymlX0lpPDKeS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014, Tanmay Inamdar wrote:
> This patch adds support for AppliedMicro X-Gene PCIe host controller. The
> driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
> cards.
> 
> X-Gene PCIe controller driver has depedency on the pcie arch support for
> arm64. The arm64 pcie arch support is not yet part of mainline Linux kernel
> and approach for arch support is under discussion with arm64 maintainers.
> The reference patch can be found here --> https://lkml.org/lkml/2013/10/23/244
> 
> If someone wishes to test PCIe on X-Gene, arch support patch must be applied
> before the patches in this patch set.

This is starting to look really good now. I have a few small comments left,
otherwise it can get merged. As mentioned in one of my review comments, it
would be good to have the arch support patch posted along with the driver.

	Arnd

