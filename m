Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab3FSBN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:13:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37437 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:13:24 -0400
X-AuditID: cbfee68e-b7f276d000002279-8e-51c105adcd7b
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
 <7174350.I5qK0sQfHM@wuerfel> <000001ce6bd7$50146e60$f03d4b20$@samsung.com>
 <201306181556.47656.arnd@arndb.de>
In-reply-to: <201306181556.47656.arnd@arndb.de>
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Wed, 19 Jun 2013 10:13:16 +0900
Message-id: <002401ce6c8a$2dd1e4a0$8975ade0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIepNJd3UbA8CoBBJYQqRm0XD6uiAEK/SvjAsQxfdYDKsJr9phj+dmQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t8zfd21rAcDDX5eM7Bo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJWxtWc1W8FP
	noqdp7+xNTBu5+pi5OSQEDCRWNY/jRHCFpO4cG89G4gtJLCMUeLZJmaYms0zngDZXEDxRYwS
	OyZNgXJ+MUrs/d3KClLFJqAm8eXLYXYQW0RAWeL4yzssIEXMAodYJSa+6WaH6FjNKLF1/Xmw
	uZwC+hINSz8xgdjCAs4SF74tAdvNIqAqsebMXbCpvAKWEgd2nmCDsAUlfky+xwJiMwtoSazf
	eZwJwpaX2LzmLdStChI7zr5mhLjCTeLEzvPsEDUiEvtevGMEOUJC4AmHRNOFi8wQywQkvk0+
	BDSUAyghK7HpANQcSYmDK26wTGCUmIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSi4z0ihNz
	i0vz0vWS83M3MUJSTN8OxpsHrA8xJgOtn8gsJZqcD0xReSXxhsZmRhamJqbGRuaWZqQJK4nz
	qrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg7DKZ1uCz/vaeZYVdt9TuvtWZMiNV55XD
	6a+LVHyVtcwWX7e6Oe9cnX300ZUJciv6czY5vT4i96YyNd99Mud7raIPZkxtGzKXyrzvETw7
	h+mOwATnTPW1b+YfLV61QWzeCo44rYcGxgqPoq/JuVTO2lN3r+zTnv2Pk2f//ZqyweZG5laB
	K084JiuxFGckGmoxFxUnAgCjl0zWRwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsVy+t9jAd21rAcDDSZ80rRo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY2vParaCnzwVO09/Y2tg3M7VxcjJISFgIrF5xhNmCFtM4sK99Wxd
	jFwcQgKLGCV2TJrCDOH8YpTY+7uVFaSKTUBN4suXw+wgtoiAssTxl3dYQIqYBQ6xSkx8080O
	0bGaUWLr+vNgczkF9CUaln5iArGFBZwlLnxbwgZiswioSqw5cxdsKq+ApcSBnSfYIGxBiR+T
	77GA2MwCWhLrdx5ngrDlJTaveQt1q4LEjrOvGSGucJM4sfM8O0SNiMS+F+8YJzAKzUIyahaS
	UbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAU9kx6B+OqBotDjAIcjEo8
	vI0rDwQKsSaWFVfmHmKU4GBWEuH9zHQwUIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgek1
	ryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY511+4BO/fJp+
	7aLGKr/wY49+PAmocew8tjMyfsmDeWJn/6aa/BY1nHH9u1U78zzxsHWTq6aty9skl17+eJa0
	zr2faheXOj561ns7QfM6/40pZ/I3iK3QXPeIKVfa2bhlt2Og6CGbHYnJKwrfBWtuNNEWjUsq
	fsbZMluwfpqm/GyDE2vbP64WUmIpzkg01GIuKk4EAKsSXeGlAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 18, 2013 10:57 PM, Arnd Bergmann wrote:
> On Tuesday 18 June 2013, Jingoo Han wrote:
> > On Monday, June 17, 2013 9:45 PM, Arnd Bergmann wrote:
> > > On Monday 17 June 2013 18:45:52 Jingoo Han wrote:
> > > > On Friday, June 14, 2013 9:54 PM, Arnd Bergmann wrote:
> > > > >

[.....]

> >
> > I will remove a 'remove' callback. Is it OK?
> > Or what should I do?
> 
> I think you should keep the remove function, but add a comment explaining that
> you don't allow module unload and that in order to allow it, the remove function
> will have to remove all pci buses and devices under the host bridge.

Then, do you mean the following?

static int __exit exynos_pcie_remove(struct platform_device *pdev)
{
	struct pcie_port *pp = platform_get_drvdata(pdev);

	clk_disable_unprepare(pp->bus_clk);
	clk_disable_unprepare(pp->clk);

	return 0;
}

static struct platform_driver exynos_pcie_driver = {
	.remove	= __exit_p(exynos_pcie_remove),

[.....]

/* Exynos PCIe driver does not allow module unload */

static int __init pcie_init(void)
{
	hook_fault_code(16 + 6, exynos_pcie_abort, SIGBUS, 0,
			"imprecise external abort");

	platform_driver_probe(&exynos_pcie_driver, exynos_pcie_probe);

	return 0;
}
subsys_initcall(pcie_init);

MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
MODULE_DESCRIPTION("Samsung PCIe host controller driver");
MODULE_LICENSE("GPLv2");


> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

