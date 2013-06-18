Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3FRFgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:36:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27174 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3FRFf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:35:58 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-d5-51bff1bb8c9c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
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
 <3539874.V7zkhbMg0b@wuerfel> <005e01ce6b3f$74e3c940$5eab5bc0$@samsung.com>
 <7174350.I5qK0sQfHM@wuerfel>
In-reply-to: <7174350.I5qK0sQfHM@wuerfel>
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Tue, 18 Jun 2013 14:35:54 +0900
Message-id: <000001ce6be5$b3fd0730$1bf71590$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIepNJd3UbA8CoBBJYQqRm0XD6uiAGZ59abAj0gpLoBCv0r45hzcHAw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t8zA93dH/cHGqx8bWLR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnissmJTUnsyy1SN8ugStjz5pP7AUn
	eCu6N1Q2MK7h6mLk5JAQMJE48uojC4QtJnHh3nq2LkYuDiGBZYwSp3/NZoMpmne7DaxISGAR
	o8SZSdkQRb8YJY70nmQCSbAJqEl8+XKYHcQWEfCUOHNyAVgDs8AsVomD+/QgGpYySuyfd4gR
	JMEpoCnRd38xWLOwgLPEhW9LwLaxCKhKbNwxD8zmFbCUWDttHwuELSjxY/I9qKFaEut3HmeC
	sOUlNq95ywxxqYLEjrOvGSGOcJPY+eAyO0SNiMS+F+8YIWrucEgs7OOB2CUg8W3yIaCZHEBx
	WYlNB6DGSEocXHGDZQKjxCwkm2ch2TwLyeZZSDYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66X
	nJ+7iRGSXHp3MN4+YH2IMRlo/URmKdHkfGByyiuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD48yZNoLvXql0ed6+VcAk8/kmT/ZUcxnXkNxVCmI8
	nfmXzYLfX+WM6c93k1samKm4lzvnxIaH66bliDzavDT48vR1C7kvXFow/evf/c9tQtSMbA9Y
	5C7Q0WkQWFrBZZysuua9WB/f697SR1XCeXZTj+4//M4mYUeXs2bh+9ePLm1z2xJ991LBHSWW
	4oxEQy3mouJEAKjSdNVEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xgO7uj/sDDU4807Vo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY8+aT+wFJ3grujdUNjCu4epi5OSQEDCRmHe7jQXCFpO4cG89G4gt
	JLCIUeLMpOwuRi4g+xejxJHek0wgCTYBNYkvXw6zg9giAp4SZ04uAGtmFpjFKnFwnx5Ew1JG
	if3zDjGCJDgFNCX67i8GaxYWcJa48G0J2AYWAVWJjTvmgdm8ApYSa6ftY4GwBSV+TL4HNVRL
	Yv3O40wQtrzE5jVvmSEuVZDYcfY1I8QRbhI7H1xmh6gRkdj34h3jBEahWUhGzUIyahaSUbOQ
	tCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZy8nkntYFzZYHGIUYCDUYmHN0Fsf6AQ
	a2JZcWXuIUYJDmYlEd6SM0Ah3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcm1rySeENjEzMj
	SyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYFxqtzxyQphU8uclEs+2nanN
	/lE85ebJKlM3jqdrZ2tv2R+2wc7rIKt3n46K+MaKDzsLuW1ORK1NFc7+HnthzdJq+fzolzMC
	hLbNllScEOG0quKAl/uF1DlHl4R0H544zevL/lsXRWOyll55WL1GxMNKLyX8Qd8nvi9X25ZV
	7ec4t4XBy+ipwxQlluKMREMt5qLiRAAOHZQ3ogMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 17, 2013 9:45 PM, Arnd Bergmann wrote:
> On Monday 17 June 2013 18:45:52 Jingoo Han wrote:
> > On Friday, June 14, 2013 9:54 PM, Arnd Bergmann wrote:
> > >
[.....]
> > > > > > +static int __exit exynos_pcie_remove(struct platform_device *pdev)
> > > > > > +{
> > > > > > +	struct pcie_port *pp = platform_get_drvdata(pdev);
> > > > > > +
> > > > > > +	clk_disable_unprepare(pp->bus_clk);
> > > > > > +	clk_disable_unprepare(pp->clk);
> > > > > > +
> > > > > > +	return 0;
> > > > > > +}
> > > > >
> > > > > You also don't remove the PCI devices here, as mentioned in an earlier
> > > > > review.
> > > >
> > > > I reviewed Marvell PCIe driver and Tegra PCIe driver; however,
> > > > I cannot know what you mean.
> > > >
> > > > Could let me know which additional functions are needed?
> > >
> > > The mvebu driver does not allow module unload. I haven't looked at the
> > > tegra driver. If you allow unloading the driver and provide a 'remove'
> > > callback, that callback needs to clean up the entire bus and remove
> > > all child devices that were added as well as undo everything the
> > > probe function did. I think it would be great if you can do that, although
> > > it might not be easy. The simplest solution would be to not support
> > > unloading though.
> >
> > As the mvebu driver uses platform_driver_probe(), the Exynos driver uses
> > platform_driver_probe(). Thus, I will not provide a 'remove' callback.
> 
> Well, the important part is not to provide a module_exit() function, which
> will ensure the driver cannot be unloaded.

Aha, I see.
I will not provide a module_exit() function), as the mvebu driver does.

Best regards,
Jingoo Han

> 
> 	Arnd

