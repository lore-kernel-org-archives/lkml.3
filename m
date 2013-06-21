Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161545Ab3FUIba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:31:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161250Ab3FUIb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:31:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH V10 0/4] PCIe support for Samsung Exynos5440 SoC
Date: Fri, 21 Jun 2013 10:30:47 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        Jason Cooper <jason@lakedaemon.net>
References: <003901ce6e50$03d039a0$0b70ace0$@samsung.com> <201306210931.58428.arnd@arndb.de> <20130621094723.312bc331@skate>
In-Reply-To: <20130621094723.312bc331@skate>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306211030.47440.arnd@arndb.de>
X-Provags-ID: V02:K0:394N+vBsFkdCgFiVhnY8bbgAsHnEerRzpc5MNUKyJrh
 w6W0gO4A28HhEGF2S+Krgs0eVD/cSSuIXNBQ6vX8RLPtGeoKBK
 xxGYao2fPO/u8Kd1HrdzV7xU2mYHiLX1KvLB2g0t1Jy4wFZE8t
 AapYDZ323FFgrmctKvFb8rD8qlbe7Jhwia6ga89l5flHYZvmt4
 /sfW/EuL0X+ZXAlj0ToN13cRu/3GMRDqUMIDn5cTwu9Rfy74vi
 S3oEaaMKNfSxRbvAHo9dko6QmTNwENPp2XeNAHQepG4LHbE8Fs
 goVUqMLEylxnTaBZ7IjgDEYVud7n916yNKhCRT6S9F9IzosFh9
 UaB9cmKrBZEbCrVLwRKE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013, Thomas Petazzoni wrote:
> I am by far not an expert on how to solve merge strategies and so on,
> but to avoid conflicts at Linus's level while merging the arm-soc and
> pci trees, it would be better if this Samsung PCIe driver could go
> through arm-soc (with Bjorn ACK, of course), so that Arnd/Olof can
> make sure the ordering is correct with regard to the of/pci changes and
> the mvebu/pci driver.

Yes, good point.

The alternative would be that Bjorn also takes the PCI branch dependencies
that are already in arm-soc into his tree. Either way works, but I agree
that what you suggest would be simpler.

	Arnd
