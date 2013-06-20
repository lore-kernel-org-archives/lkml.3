Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3FTJD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:03:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3FTJD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:03:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 11:03:47 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
In-Reply-To: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201103.47855.arnd@arndb.de>
X-Provags-ID: V02:K0:r754rbMqnVsiXVE4Z1KoTG76U0W3st7sxnJVP/zzPbM
 +tqYdeG8/C7/yapuXBAqqWOGeQ+8YZnKf9cU8vZoM9ToVLO3vW
 IaK8qF7WxRejQdBW6NBVNG6FL4txnbg5gFw39oo3Rql4VLGMAS
 YTN9jgkGUjkguwcd9OibY5Wm0/DO2oOQ81zVGeRqArKFDQZJH1
 RITKiviXY3tLjV/rlmEDS1gkRChu6cyKn53duonZ/Y/jzvjVFL
 +IvIfjBZAujeYhh9ZNSZKB4tt2OkhzE5rRL8oFFPveP6wVQOdI
 A/e2IDE8ws6GDYWoTby3dQgOS4gq8PLkKPhROBoP0zu0OIyRfC
 i6FHLjooiDGAh7eo3MSA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Jingoo Han wrote:
> Exynos5440 has two PCIe controllers which can be used as root complex
> for PCIe interface.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
