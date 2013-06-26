Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3FZSRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:17:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3FZSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:17:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH V10 1/4] pci: Add PCIe driver for Samsung Exynos
Date: Wed, 26 Jun 2013 20:17:04 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
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
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, Olof Johansson <olof@lixom.net>
References: <003a01ce6e50$6d5418b0$47fc4a10$@samsung.com> <20130625021102.GA13310@google.com> <007e01ce7153$4d4b0730$e7e11590$%kim@samsung.com>
In-Reply-To: <007e01ce7153$4d4b0730$e7e11590$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306262017.04689.arnd@arndb.de>
X-Provags-ID: V02:K0:JzoeYAw110zQhwoxU+33LzQpWNO5HaKzoehJJeBmVxH
 jxGrW71Wfdov4Up0QMNlW7uRka4MftE9yTWiQLQVaDweiUEkU+
 hSAtos76AV4t6AMU/8z0aKD7SLZczwtiaCYi4NnaNgkU3asZw8
 vb/MyoYXlBdd1EtGUY5nbyrVAQ/4xqcT4LssoajDChObz8wOv+
 LLP0lUZaeZC42tqqyakAl7TUgesUNxFPvtO9DnHlQGqwqgYcFb
 +Rn3BRpXpz7WOEoSc/bMKFIlX3IBPA+0B+0xbeFXRKm+/DghT0
 hsDOOel9zBkupKu/kUBl5YSP/K2EwhDniHirlye3M1dE8g0E47
 dSsOWkYSeon6KTOlHE5Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 June 2013, Kukjin Kim wrote:
> Bjorn Helgaas wrote:
> > 
> > On Fri, Jun 21, 2013 at 04:24:54PM +0900, Jingoo Han wrote:
> > > Exynos5440 has a PCIe controller which can be used as Root Complex.
> > > This driver supports a PCIe controller as Root Complex mode.
> > >
> > > Signed-off-by: Surendranath Gurivireddy Balla <suren.reddy@samsung.com>
> > > Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > Please merge this through arm-soc as you discussed.
> > 
> Sounds great.
> 
> Arnd, please take this series into arm-soc tree directly by yourself with my
> ack on arch/exynos stuff if you want ;)
> 

Ok, done.

I've put this on top of the next/soc tree, which already contains the
other PCI host controller support.

	Arnd
