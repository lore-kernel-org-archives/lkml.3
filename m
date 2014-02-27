Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaB0NXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:23:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:58950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaB0NXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:23:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/4] pci: Introduce a domain number for pci_host_bridge.
Date: Thu, 27 Feb 2014 14:22:39 +0100
Message-ID: <7263969.1aniqAkfKX@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1393506402-11474-4-git-send-email-Liviu.Dudau@arm.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <1393506402-11474-4-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:L2JovWySWsSk1SIoc1zddR5HSH+EhTGvXG3dE0JEnEy
 YoBZCW71ms2GnmbJkRy7B00/W7+I8/udmfx09KAP5e8nBC+vsd
 iYkSYwUy7iSCtA35odaWjD5zG2Ust5KMzt/uxy2JdkFbxmXLlY
 MX3TbQmE5HYKcR3nxG5aCe/Myw4n5O6g2Hxe7oFo3fhyEm9XD2
 emsxU+0LAV5Ifw2NnJexp+yj4xec6oGTcXyxmnHx/uj4i3G5oI
 96ttkRvqW3sUku5z8ogMgPVREdnlE9ZPJwtwJbFNYCKn69xf7G
 xtnVyp3a33wAfPGOZq70lSNLNkcJuOhthXoR9YBHPM428B3Ntq
 CYmFLrmg2Px5dy8vh1hA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 13:06:41 Liviu Dudau wrote:
> Make it easier to discover the domain number of a bus by storing
> the number in pci_host_bridge for the root bus. Several architectures
> have their own way of storing this information, so it makes sense
> to try to unify the code. While at this, add a new function that
> creates a root bus in a given domain and make pci_create_root_bus()
> a wrapper around this function.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
