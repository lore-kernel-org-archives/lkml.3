Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056Ab3FTGlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:41:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14998 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3FTGlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:41:44 -0400
X-AuditID: cbfee68e-b7f276d000002279-fe-51c2a4269f85
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <000b01ce6839$0f0455d0$2d0d0170$@samsung.com>
 <201306181556.47656.arnd@arndb.de>
 <002401ce6c8a$2dd1e4a0$8975ade0$@samsung.com>
 <201306191443.09598.arnd@arndb.de>
In-reply-to: <201306191443.09598.arnd@arndb.de>
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Thu, 20 Jun 2013 15:41:42 +0900
Message-id: <00be01ce6d81$39743950$ac5cabf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIepNJd3UbA8CoBBJYQqRm0XD6uiAMqwmv2AsxxTtIB5T8o75he1Esw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t8zY121JYcCDfa26Fk0/9/OavF30jF2
	iyVNGRYHZj9ktXh1ZiObxeWFl1gtvt8wtehdcJXNYtPja6wWl3fNYbM4O+84m8WM8/uYLFY0
	bWW0WHxxObPF7pVLWCyOzVjCaPH0QROTg6DHmnlrGD1+/5rE6NE35Sqbx5NNFxk9Fmwq9bhz
	bQ+bx+Yl9R7nZyxk9Pi+oxeoYMsqRo+fL3U8Pm+SC+CJ4rJJSc3JLEst0rdL4Mp4/vsFU8FE
	noopc4IbGKdzdjFyckgImEhcezaZHcIWk7hwbz1bFyMXh5DAMkaJ3z+/s8AUHZl7mB0iMZ1R
	YvO8/4wQzi+gqjf7WUGq2ATUJL58OQw2SkRAWeL4yzssIEXMAodYJSa+6YZq38woceL0HyaQ
	Kk4BfYnJa/cxg9jCAs4SF74tYQOxWQRUJU7f+gJm8wpYSqzs3M0MYQtK/Jh8D+wmZgEtifU7
	jzNB2PISm9e8ZYa4VUFix9nXjBBXuElMPLsQql5EYt+Ld2BnSwg84JB41rGEFWKZgMS3yYeA
	ijiAErISmw5AzZGUOLjiBssERolZSFbPQrJ6FpLVs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4
	NC9dLzk/dxMjJMX07WC8ecD6EGMy0PqJzFKiyfnAFJVXEm9obGZkYWpiamxkbmlGmrCSOK9a
	i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsag/w9XT5p/q3Z988LXF5Zbv7o9/RDT5Rdx
	Xqftsx42HCi7fZd1129jtS+FHPM1p8Zp/gk7/63Jbq3CZInlSwvnyIZU/zPx+/sqVLDkUfuM
	c/HLV9z6sCpwtuti9iciJ/uXru0+nfXv2NrHopIbqy5WVsgcqflbe10yLev+v9PXDkRbTNe5
	qN0up8RSnJFoqMVcVJwIAC8oNI9HAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsVy+t9jQV21JYcCDTraNSya/29ntfg76Ri7
	xZKmDIsDsx+yWrw6s5HN4vLCS6wW32+YWvQuuMpmsenxNVaLy7vmsFmcnXeczWLG+X1MFiua
	tjJaLL64nNli98olLBbHZixhtHj6oInJQdBjzbw1jB6/f01i9OibcpXN48mmi4weCzaVety5
	tofNY/OSeo/zMxYyenzf0QtUsGUVo8fPlzoenzfJBfBENTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gD9paRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPMeP77BVPBRJ6KKXOCGxinc3YxcnJICJhIHJl7mB3CFpO4cG89Wxcj
	F4eQwHRGic3z/jNCOL8YJX6/2c8KUsUmoCbx5QtEh4iAssTxl3dYQIqYBQ6xSkx8080O0bGZ
	UeLE6T9MIFWcAvoSk9fuYwaxhQWcJS58W8IGYrMIqEqcvvUFzOYVsJRY2bmbGcIWlPgx+R4L
	iM0soCWxfudxJghbXmLzmrfMELcqSOw4+5oR4go3iYlnF0LVi0jse/GOcQKj0Cwko2YhGTUL
	yahZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOYM+kdjCubLA4xCjAwajEw6tx
	+WCgEGtiWXFl7iFGCQ5mJRHe1DmHAoV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5hc80ri
	DY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBceKube9ORQUmcZ2Z
	b85oapue+VdP+UHI9yv9LVw1ZgcEWCa+Wnmvu5nnr1DRafat/Ql3pzkyZXIwCnWbLf+7fXX9
	i+LJpz/oM9/482zy+ROPz0/Zc6Vbd+GxC6YTNQXFfbRsGHfxbj1c5t6u/PrXA48Xn1iaNnhw
	P4oIazkaeCCZ9bvt3zm6X5RYijMSDbWYi4oTAegTgWKkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 9:43 PM, Arnd Bergmann wrote:
> On Wednesday 19 June 2013, Jingoo Han wrote:
> > Then, do you mean the following?
> >
> > static int __exit exynos_pcie_remove(struct platform_device *pdev)
> > {
> >         struct pcie_port *pp = platform_get_drvdata(pdev);
> >
> >         clk_disable_unprepare(pp->bus_clk);
> >         clk_disable_unprepare(pp->clk);
> >
> >         return 0;
> > }
> >
> > static struct platform_driver exynos_pcie_driver = {
> >         .remove = __exit_p(exynos_pcie_remove),
> >
> > [.....]
> >
> > /* Exynos PCIe driver does not allow module unload */
> >
> > static int __init pcie_init(void)
> > {
> >         hook_fault_code(16 + 6, exynos_pcie_abort, SIGBUS, 0,
> >                         "imprecise external abort");
> >
> >         platform_driver_probe(&exynos_pcie_driver, exynos_pcie_probe);
> >
> >         return 0;
> > }
> > subsys_initcall(pcie_init);
> >
> > MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
> > MODULE_DESCRIPTION("Samsung PCIe host controller driver");
> > MODULE_LICENSE("GPLv2");
> >
> 
> Yes, this looks good. I would probably use platform_driver_register
> rather than platform_driver_probe, but that is your choice. using
> platform_driver_probe() mean you cannot deal with deferred probing.

Hi Arnd,

Thank you for your reply. :)
I will send PATCH v6, soon.
I really appreciate your comments.

Hi Thomas Abraham, Kukjin Kim,
Thank you for your support.
It is very helpful.


Best regards,
Jingoo Han


