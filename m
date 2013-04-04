Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094Ab3DDA5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:57:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49188 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762904Ab3DDA5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:57:36 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e3-515ccfff14c3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Andrew Murray'" <Andrew.Murray@arm.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20130326162022.GA25625@arm.com>
 <20130327130418.GA10480@avionic-0098.mockup.avionic-design.de>
In-reply-to: <20130327130418.GA10480@avionic-0098.mockup.avionic-design.de>
Subject: Re: [PATCH v3] of/pci: Provide support for parsing PCI DT ranges
 property
Date: Thu, 04 Apr 2013 09:57:34 +0900
Message-id: <002b01ce30cf$64da6180$2e8f2480$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4q65z/zDBbhQSyS9yD4tC3iMkrxAF43cBg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t8zY93/52MCDR6e57do/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWdy+
	zGtxYGk7i8WKpq2MFosvLme22L1yCYvFsRlLGC2ePmhichD2WDNvDaNHS3MPm8fvX5MYPfqm
	XGXzeLLpIqPHgk2lHneu7WHz2Lyk3uP8jIWMHt939AIVbFnF6PHzpY7H501yAbxRXDYpqTmZ
	ZalF+nYJXBmPJp1hLNjPWzH1tXED42OuLkZODgkBE4k7184zQ9hiEhfurWfrYuTiEBJYxiix
	p+c9C0zRtGMPmSASixgl9r66CtYhJPCLUaJrhzCIzSagJvHly2F2EFtEIEliZ/82RpAGZoGH
	rBIbbp5hgWjIldj++SoTiM0p4C0xf8knNhBbWCBE4vfj62BDWQRUJc79fcIKYvMK2Eps/9nP
	DmELSvyYfA9sDrOAlsTmbU2sELa8xOY1b4F6OYAuVZd49FcX4gYjieX7pkGViEjse/EO7B4J
	gS8cEqt+bWaB2CUg8W3yIRaIXlmJTQegISEpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWj
	aGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSOKZuIPx/gHrQ4zJQOsnMkuJJucDE1deSbyhsZmR
	hamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgZ/ZcLidq0BaYk
	blkmsttD/r4Tx4/wafYLj72Ji9XYpHDhy536iLvaWpOZbqtvOFz3xnC948Gv7quS3yde3cze
	k/t77r9t/y4kG4o0u3pGvT9z1Cxyb87BC2aaN6v6ju60KY/derZGKz/xzofIogvxN5bcNmK9
	qyisePmxpKn5bZa9BStDuP2VWIozEg21mIuKEwGxnB2JUgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsVy+t9jAd3/52MCDR7M5rBo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWdy+
	zGtxYGk7i8WKpq2MFosvLme22L1yCYvFsRlLGC2ePmhichD2WDNvDaNHS3MPm8fvX5MYPfqm
	XGXzeLLpIqPHgk2lHneu7WHz2Lyk3uP8jIWMHt939AIVbFnF6PHzpY7H501yAbxRDYw2GamJ
	KalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBfKimUJeaUAoUC
	EouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzHk06w1iwn7di6mvjBsbHXF2MnBwSAiYS
	0449ZIKwxSQu3FvP1sXIxSEksIhRYu+rq8wgCSGBX4wSXTuEQWw2ATWJL18Os4PYIgJJEjv7
	tzGCNDALPGSV2HDzDAtEQ67E9s9XwaZyCnhLzF/yiQ3EFhYIkfj9+DrYUBYBVYlzf5+wgti8
	ArYS23/2s0PYghI/Jt8Dm8MsoCWxeVsTK4QtL7F5zVugXg6gS9UlHv3VhbjBSGL5vmlQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC09oz
	6R2MqxosDjEKcDAq8fCu8I8JFGJNLCuuzD3EKMHBrCTCu2ElUIg3JbGyKrUoP76oNCe1+BBj
	MtCjE5mlRJPzgSk3ryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4
	pRoYtTObFpYKv+H7svP/4QJxvf97NYLy3cN01rbx6h7YyC0n7C5x3Uh1d230sXQGd2H7aT8V
	zPtYVUXrrJ/4x4ttfRn3ceG0OzYd1Txyj65c2nrrfN1pxj2WFnsfuGbdZ2Wewh28RJvtQsPx
	ulVte/fMYZk5m5G5LuqnS+fKZNem1ouhW749N+JUYinOSDTUYi4qTgQAIjrzEa8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 27, 2013 10:04 PM, Thierry Reding wrote:
> 
> On Tue, Mar 26, 2013 at 04:20:23PM +0000, Andrew Murray wrote:
> > This patch factors out common implementation patterns to reduce overall kernel
> > code and provide a means for host bridge drivers to directly obtain struct
> > resources from the DT's ranges property without relying on architecture specific
> > DT handling. This will make it easier to write archiecture independent host bridge
> > drivers and mitigate against further duplication of DT parsing code.
> >
> > This patch can be used in the following way:
> >
> > 	struct of_pci_range_parser parser;
> > 	struct of_pci_range range;
> >
> > 	if (of_pci_range_parser(&parser, np))
> > 		; //no ranges property
> >
> > 	for_each_of_pci_range(&parser, &range) {
> >
> > 		/*
> > 			directly access properties of the address range, e.g.:
> > 			range.pci_space, range.pci_addr, range.cpu_addr,
> > 			range.size, range.flags
> >
> > 			alternatively obtain a struct resource, e.g.:
> > 			struct resource res;
> > 			of_pci_range_to_resource(&range, np, &res);
> > 		*/
> > 	}
> >
> > Additionally the implementation takes care of adjacent ranges and merges them
> > into a single range (as was the case with powerpc and microblaze).
> >
> > The modifications to microblaze, mips and powerpc have not been tested.
> >
> > Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>

It works properly with Exynos5440.

Tested-by: Jingoo Han <jg1.han@samsung.com>



