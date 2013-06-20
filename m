Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3FTIAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:00:21 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3FTIAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:00:18 -0400
Date: Thu, 20 Jun 2013 10:00:13 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Subject: Re: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Message-ID: <20130620100013.6000458f@skate>
In-Reply-To: <00c301ce6d8b$d198b210$74ca1630$@samsung.com>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
	<20130620094835.3f1f34c2@skate>
	<00c301ce6d8b$d198b210$74ca1630$@samsung.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jingoo Han,

On Thu, 20 Jun 2013 16:57:32 +0900, Jingoo Han wrote:

> > > -	pinctrl {
> > > +	pin_ctrl: pinctrl {
> > >  		compatible = "samsung,exynos5440-pinctrl";
> > 
> > I know I'm nitpicking, but isn't this change completely unrelated to
> > PCIe support?
> 
> This change is related to PCIe support.
> Without this, I cannot use gpio binding.
> 
> This change was guided by Thomas Abraham (Author of Samsung pinctrl).
> Also, it was confirmed by Kukjin Kim (Maintainer of Samsung SoC).
> 
> Thank you for your caring. :)

I mean, the change is fine for sure, but it should maybe part of a
separate patch as it is more a fix than really the introduction of the
PCIe controller node, as the patch title suggests. This would also for
example allow this fix to be merged right now (for 3.11), regardless of
what happens for the rest of your PCIe patches.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
