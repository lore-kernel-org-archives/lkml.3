Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaB0NWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:22:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:56456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaB0NWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:22:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/4] pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
Date: Thu, 27 Feb 2014 14:22:13 +0100
Message-ID: <6845675.ZDsMtaSPuS@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1393506402-11474-3-git-send-email-Liviu.Dudau@arm.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <1393506402-11474-3-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:esLHAFSLR90FI3b/Ae1AyRif3JJgjvF1lPEsgt7Oiep
 Q09HhSaNisWB9vrkfWwzpzBEQOcx2CjLzd4anqWJ2X3ZLFj+cn
 10Qg8OBthAWrO0Sl7v6xR8PZeRBTBYROK2GmHKIrDSbJkx3xyo
 j2DjyKPwdGUQQDVX1pvu7RGiCteBnxtQZCh8jiwdubCvTjryi9
 QuvJFKjphxWfvc+fBWFetaoEMWcTdOtqUoOvpqLRogPOxTf3pd
 Ad9uiT8/xZzVEB9frbK7anoas6ajj/jCr2kfd+dtSULGCmcgWd
 Sz2yBZdEa65a+Mtq3xoWRzNphmKl9lEBiltphb+el/gV8Shg4R
 fJKALnNZY4Zp+ByBGssU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 13:06:40 Liviu Dudau wrote:
> Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
> As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
> the creation order has been changed for no good reason. Revert the order of
> creation as we are going to depend on the pci_host_bridge structure to retrieve the
> domain number of the root bus.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 

Looks good to me.

	Arnd
