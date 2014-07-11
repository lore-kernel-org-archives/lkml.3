Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaGKM62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:58:28 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:53914 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbaGKM6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:58:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3/3] arm64: Use include/asm-generic/io.h
Date: Fri, 11 Jul 2014 14:58:09 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com> <201407101514.16530.arnd@arndb.de> <20140711121923.GE11473@arm.com>
In-Reply-To: <20140711121923.GE11473@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407111458.09884.arnd@arndb.de>
X-Provags-ID: V02:K0:JhfbXeILLur5R7tUpMrzlOKWJcguPIO+SxMESpLAEuZ
 F9pMpH2mrwM4U2dPlP6u+uYAHdi54pz6GZf4wkIK0pw3fXiw43
 3kgSFIBykIxn2FoHIT5fxvV5f5fqqH4zwFRMs3qkPk3zbVspAn
 AAOfqijjZkOSRpXV9lfPC6mBX9S6tdWq36AfOgMgL/b8HCVRYe
 Zrqyktz8/21VlFUkkrK4XckdhH4qJtYg5QiTFK2Njjj7vQpG2c
 PnFk0Py32ySImzB+u1BqLydW1X8+4Osv0v/R9zIZ0fYV3O3cw7
 m3/4aDuvEITtklH1LqdP+98lK5Dj1bOPKLh4pQeIDZ7WBNLzPB
 TnfyPe6l3NqYrHzIQLAN75UefOvdtXCh/cp8oVzEy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2014, Catalin Marinas wrote:
> ioread32() is indeed an alias for readl on arm64 but if the address it
> gets as argument looks like an I/O port, it adds PCI_IOBASE (via the inl
> macro). This would no longer happen with Thierry's patches.
> 
> So I guess that for this patch to work, we also need ioport_map() to
> return an address from the PCI_IOBASE range. Should we merge this now as
> well:
> 
> http://linux-arm.org/git?p=linux-ld.git;a=commitdiff;h=3423064d8e42a38164a8436bcdf7434cf9cd2192

This is also part of patch 1/3 in Thierry's series.

	Arnd
