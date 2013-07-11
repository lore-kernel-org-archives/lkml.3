Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3GKX2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:28:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43373 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3GKX2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:28:08 -0400
X-AuditID: cbfee68e-b7f276d000002279-2d-51df3f862d92
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <001201ce7dfa$716b3370$54419a50$@samsung.com>
 <20130711154121.GC2198@dhcp-172-17-186-34.nvidia.com>
In-reply-to: <20130711154121.GC2198@dhcp-172-17-186-34.nvidia.com>
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Fri, 12 Jul 2013 08:28:05 +0900
Message-id: <000301ce7e8e$4b7d9420$e278bc60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMw1eBP/VKXWuT2/qwqXEWC1QeRsgK7UvgiloWUXzA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+ZkW6b/f1Ag7dfmC3+TjrGbrGkKcPi
	5SFNi8sLL7Fa9C64ymZx4WkPm8XlXXPYLM7OO85mMeP8PiaLjVN/MVq0X1K2+LlrHotF49EH
	rBatTx4wOvB5/P41idFj56y77B4LNpV6fF84n92jb8sqRo+nP/Yyexy/sZ3J4/MmuQCOKC6b
	lNSczLLUIn27BK6M1+e62QuWcla0XpvF2MC4i72LkZNDQsBE4un8DmYIW0ziwr31bF2MXBxC
	AssYJX7eeckIU7SwezoTRGIRo8SRKb1QVb8YJV7O/ccCUsUmoCbx5cthsLEiAvoSl65fYgWx
	mQVOMktsmyIBYgsJFEq0v+gAq+EUcJJ4duIT2AZhgUSJfysfAA3l4GARUJVovK4NEuYVsJTY
	+nUvE4QtKPFj8j0WiJFaEut3HmeCsOUlNq95C/WBgsSOs68ZQcaICFhJnF+vAFEiIrHvxTtG
	kJMlBLZwSLx/vgKsnkVAQOLb5EMsIPUSArISmw5AjZGUOLjiBssERolZSDbPQrJ5FpLNs5Cs
	WMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJDH07WC8ecD6EGMy0PqJzFKiyfnAxJJX
	Em9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsb+/xIn
	GzM9fjP1GehZLf4v6lj5+sDbH3Nj7zT2cu+WvXOlZtU9bZ4HooKHH7w1svAzqbFdaVT34h2v
	nV3ch+CYR8fWyFjseDBd6N2Ef3EKn85F9tS6X2h19PyTYXftbNGXNV3yl/XlOGSOP9sfahlb
	fuau1cljh8uCLv9nPSo742v3FIkne72UWIozEg21mIuKEwGQU/AjIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jAd1W+/uBBp/XW1v8nXSM3WJJU4bF
	y0OaFpcXXmK16F1wlc3iwtMeNovLu+awWZydd5zNYsb5fUwWG6f+YrRov6Rs8XPXPBaLxqMP
	WC1anzxgdODz+P1rEqPHzll32T0WbCr1+L5wPrtH35ZVjB5Pf+xl9jh+YzuTx+dNcgEcUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVysplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM16f62YvWMpZ0XptFmMD4y72LkZO
	DgkBE4mF3dOZIGwxiQv31rN1MXJxCAksYpQ4MqUXyvnFKPFy7j8WkCo2ATWJL18Og3WLCOhL
	XLp+iRXEZhY4ySyxbYoEiC0kUCjR/qIDrIZTwEni2YlPjCC2sECixL+VD4CGcnCwCKhKNF7X
	BgnzClhKbP26lwnCFpT4MfkeC8RILYn1O48zQdjyEpvXvGWGOFRBYsfZ14wgY0QErCTOr1eA
	KBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	nHaeSe9gXNVgcYhRgINRiYe34MS9QCHWxLLiytxDjBIczEoivDfN7gcK8aYkVlalFuXHF5Xm
	pBYfYkwG+nMis5Rocj4wJeaVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUI
	ZgsTB6dUA+OC0PTiiaL/JN7u4jK5+eb514IpHc/10q5MWO66zVqtY+OxV7v31+dcY4mbEbpr
	ten0IBWBGZl27FekOQr/b1m7OPRi2m0H+RWLHljOeN5qLKOt07EsN+jOyc3M5673/G2c0yAd
	flPPU0fOKv7bKcakOyd2lm+RKb78L0Nu26OuE3/MLO+nL6lSYinOSDTUYi4qTgQAHuOSr38D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 12, 2013 12:41 AM, Thierry Reding wrote:
> On Thu, Jul 11, 2013 at 02:49:43PM +0900, Jingoo Han wrote:
> [...]
> > diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
> [...]
> >  obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
> >  obj-$(CONFIG_PCIE_DW) += pcie-designware.o
> > +obj-$(CONFIG_PCI_EXYNOS) += pcie-exynos.o
> 
> I think we should keep these sorted alphabetically. Also Tegra and
> Marvell are PCIe controllers but they still use the pci- prefix instead
> of pcie-. Perhaps it'd be good to keep consistency here? I initially
> chose pci- because from a software point of view it doesn't matter all
> that much whether it's PCI or PCIe and because the drivers are part of
> the PCI subsystem. However if Exynos now uses the pcie- prefix it makes
> it look like Tegra and Marvell are plain old PCI.
> 

Hi Thierry,

I initially chose 'pci-' prefix such as 'pci-designware.c'.

However, Pratyush Anand suggested as below:
"I would suggest to rename it as pcie-designware.c,
because synopsis pcie and pci controllers are different."

If you have a good idea, please give it to me. :)
Thank you.

Best regards,
Jingoo Han


