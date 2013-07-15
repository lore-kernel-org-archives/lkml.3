Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3GOI0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:26:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39537 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3GOI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:26:10 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-b6-51e3b2204f91
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
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org
References: <001201ce7dfa$716b3370$54419a50$@samsung.com>
 <20130711154121.GC2198@dhcp-172-17-186-34.nvidia.com>
 <000301ce7e8e$4b7d9420$e278bc60$@samsung.com>
 <20130712171529.GA9620@dhcp-172-17-186-34.nvidia.com>
In-reply-to: <20130712171529.GA9620@dhcp-172-17-186-34.nvidia.com>
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Mon, 15 Jul 2013 17:26:07 +0900
Message-id: <000a01ce8134$f44554f0$dccffed0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMw1eBP/VKXWuT2/qwqXEWC1QeRsgK7UvgiAjhFvB4BVHqXDJZufW+Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t8zY12FTY8DDWav5rP4O+kYu8WSpgyL
	l4c0LS4vvMRq0bvgKpvFhac9bBaXd81hszg77zibxYzz+5gsNk79xWjRfknZ4ueueSwWjUcf
	sFq0PnnA6MDn8fvXJEaPnbPusnss2FTq8X3hfHaPvi2rGD2e/tjL7HH8xnYmj8+b5AI4orhs
	UlJzMstSi/TtErgyPjZPZitYwVdxbe4Z5gbG+dxdjJwcEgImEoubXrBA2GISF+6tZ+ti5OIQ
	EljGKHG6YS9rFyMHWFH7rTKI+HRGid0f3jFCOL8YJVadPccM0s0moCbx5cthdhBbREBf4tL1
	S6wgRcwCJ5kl/t+5xAzRcZNR4sWZV6wgVZwCThINLVOYQGxhgUSJfysfsIHYLAKqEqdXvQSr
	4RWwlNjTdJ4FwhaU+DH5HpjNLKAlsX7ncSYIW15i85q3zBA/KEjsOPuaEeIKN4lPS1uh6kUk
	9r2AOFtCYAeHxKSfa5ghlglIfJt8iAXiT1mJTQeg5khKHFxxg2UCo8QsJKtnIVk9C8nqWUhW
	LGBkWcUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRkh56dzDePmB9iDEZaP1EZinR5Hxgeskr
	iTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PpBvUt
	zyPfLPqZOLF6uVHbcvEUw9D7DlbnN/1oWvPku4rgrL/uQQI6ZXZmzTKvklpKrpX/28KS/Orz
	qjmrvmU/mD+Xz7okTleuz9bVaPZzq4PFh378s9723+Lq2e43OaJalS3qjz6oCc/60bydI2eK
	bQFDknNTNN+utYkbtDq0eOeLcX5vvazEUpyRaKjFXFScCABf8yU/JQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jQV2FTY8DDaY84rD4O+kYu8WSpgyL
	l4c0LS4vvMRq0bvgKpvFhac9bBaXd81hszg77zibxYzz+5gsNk79xWjRfknZ4ueueSwWjUcf
	sFq0PnnA6MDn8fvXJEaPnbPusnss2FTq8X3hfHaPvi2rGD2e/tjL7HH8xnYmj8+b5AI4ohoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlZSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZnxsnsxWsIKv4trcM8wNjPO5uxg5
	OCQETCTab5V1MXICmWISF+6tZ+ti5OIQEpjOKLH7wztGCOcXo8Sqs+eYQarYBNQkvnw5zA5i
	iwjoS1y6fokVpIhZ4CSzxP87l5ghOm4ySrw484oVpIpTwEmioWUKE4gtLJAo8W/lAzYQm0VA
	VeL0qpdgNbwClhJ7ms6zQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhniVgWJHWdfM0Jc4Sbx
	aWkrVL2IxL4X7xgnMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4OTzTGoH48oGi0OMAhyMSjy8BzQeBwqxJpYVV+YeYpTgYFYS4V2m/ChQiDclsbIqtSg/
	vqg0J7X4EGMy0KcTmaVEk/OBiTGvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2amp
	BalFMFuYODilGhgLo8wt6xv1W6aLK23ftTjv9ZfTcyenFqWvfNIds+R8dXjQp+8KHefW1rCx
	MT1/6OPoG7XOZ3OT39flTpME2nINOwz9+j0/b3pjHJr7IfFIg27r6uOurv6uRwWnqV8LMlqo
	+/J87v5e1YCPar8Cd215c1z13YwXgp+/xSkcPjn1zY9dYTvu/XNTYinOSDTUYi4qTgQAOpHc
	nIIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 13, 2013 2:16 AM, Thierry Reding wrote:
> On Fri, Jul 12, 2013 at 08:28:05AM +0900, Jingoo Han wrote:
> > On Friday, July 12, 2013 12:41 AM, Thierry Reding wrote:
> > > On Thu, Jul 11, 2013 at 02:49:43PM +0900, Jingoo Han wrote:
> > > [...]
> > > > diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
> > > [...]
> > > >  obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
> > > >  obj-$(CONFIG_PCIE_DW) += pcie-designware.o
> > > > +obj-$(CONFIG_PCI_EXYNOS) += pcie-exynos.o
> > >
> > > I think we should keep these sorted alphabetically. Also Tegra and
> > > Marvell are PCIe controllers but they still use the pci- prefix instead
> > > of pcie-. Perhaps it'd be good to keep consistency here? I initially
> > > chose pci- because from a software point of view it doesn't matter all
> > > that much whether it's PCI or PCIe and because the drivers are part of
> > > the PCI subsystem. However if Exynos now uses the pcie- prefix it makes
> > > it look like Tegra and Marvell are plain old PCI.
> > >
> >
> > Hi Thierry,
> >
> > I initially chose 'pci-' prefix such as 'pci-designware.c'.
> >
> > However, Pratyush Anand suggested as below:
> > "I would suggest to rename it as pcie-designware.c,
> > because synopsis pcie and pci controllers are different."
> >
> > If you have a good idea, please give it to me. :)
> 
> Alternatively the plain old PCI variant could be suffixed -legacy or
> similar, but I guess pcie- as a prefix works okay in this case.
> 
> However I still think you should sort them properly:
> 
> 	obj-$(CONFIG_PCIE_DW) += pcie-designware.o
> 	obj-$(CONFIG_PCI_EXYNOS) += pci-exynos.o
> 	obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o

Hi Thierry Reding,

Thank you for your suggestion. :)
I will use it as you guided.

Best regards,
Jingoo Han


