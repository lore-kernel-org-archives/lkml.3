Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030443Ab3FUHcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:32:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161061Ab3FUHco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:32:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V10 0/4] PCIe support for Samsung Exynos5440 SoC
Date: Fri, 21 Jun 2013 09:31:58 +0200
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
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>
References: <003901ce6e50$03d039a0$0b70ace0$@samsung.com>
In-Reply-To: <003901ce6e50$03d039a0$0b70ace0$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306210931.58428.arnd@arndb.de>
X-Provags-ID: V02:K0:UOVDZ8P4AxcFLqx11A8GgjwnvBBFhjypjG0ev2pLKDR
 46xSWgkuUMMZ1NWOMVrYC4DeSu6szyxUHU9mt2zv4sL7us0FYQ
 uUEfe3uW8XSRVQKvghM7tIJbkwOPjr/Kx5oH5JiX5cm9xIDtZe
 e7CSwrONT05LlLwrr1L230b7LDsEgEtD1wRVxF2tCrgSdL5Cy1
 vDI5lBfgDSbQ7X5ukNmC7WKAgwSLsSpq12XHCAvlhS4WI3X62D
 ppevtVKMzVE3k120kMTSRe5m6/bOk2mNcQztTxj8tufg0WFTz5
 bqcnCTZpuuGGEgmruVveoGpk5WYpBGzZhzxzxGNjsnSVJzqPJV
 azAvysKsN8Rb4f/U6yYI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013, Jingoo Han wrote:
> Changes between v9 and v10:
>   * Changed the file name from 'pci-designware.c' to 'pcie-designware.c'
>     guided by Pratyush Anand, because synopsis pcie and pci controllers
>     are different.
>   * Fixed the typos of document, reported by Sachin Kamat.
> 
> Changes between v8 and v9:
>   * Changed the file name from 'exynos-pcie.txt' to 'designware-pcie.txt'.
>   * Added 'snps,dw-pcie' string to compatible property.
> 
> Changes between v7 and v8:
>   * Changed the file name from 'pci-exynos.c' to 'pci-designware.c',
>     and added a generic string for compatible property to exynos-pcie.txt
>   * Moved pci_add_resource_offset() for I/O space to the 'if' clause
>   * Added Arnd's Acked-by
> 
> Changes between v6 and v7:
>   * Split ARM DT patch to two patches
>   * Fixed node naming
>   * Added Arnd's Acked-by

Ok, that takes care of all my comments.

Bjorn, are you still considering to merge this for 3.11 or have you
closed your tree for the merge window? I think it would be good to get
it in.

	Arnd
