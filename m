Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3FTHs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:48:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:45944 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3FTHsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:48:40 -0400
Date: Thu, 20 Jun 2013 09:48:35 +0200
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
Message-ID: <20130620094835.3f1f34c2@skate>
In-Reply-To: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jingoo Han,

On Thu, 20 Jun 2013 16:12:24 +0900, Jingoo Han wrote:

> -	pinctrl {
> +	pin_ctrl: pinctrl {
>  		compatible = "samsung,exynos5440-pinctrl";

I know I'm nitpicking, but isn't this change completely unrelated to
PCIe support?

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
