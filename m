Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaEHI4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:56:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46060 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaEHI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:56:41 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-7b-536b46c71ea3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Marek Vasut'" <marex@denx.de>, devicetree@vger.kernel.org,
        balajitk@ti.com, linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-omap@vger.kernel.org,
        rogerq@ti.com, "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Thierry Reding'" <treding@nvidia.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
 <20140506163507.GA15542@obsidianresearch.com> <5369FB67.6040905@ti.com>
 <5525000.bPgPLB3ZrT@wuerfel>
In-reply-to: <5525000.bPgPLB3ZrT@wuerfel>
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for pcie-dra7xx
 controller
Date: Thu, 08 May 2014 17:56:38 +0900
Message-id: <000101cf6a9b$6c96c8d0$45c45a70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9p1nExV68ahqdKT2aUZWVvSQRKHQAw93UA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t8zA93jbtnBBtceqFj8nXSM3WLq5O1s
	FkuaMixeHtK0mH/kHKvF5YWXWC2+3zC1uPC0h81i0+NrrBYL25awWFzeNYfNYvaSfhaLs/OO
	s1m8aWtktNg49RejRfslZYueR1oWt3/zOQh5/P41idFj3qwTLB4LNpV6bF5S79Hb/I7N4/uO
	XkaPvi2rGD2e/tjL7HH8xnYmj8+b5AK4orhsUlJzMstSi/TtErgydm0+zFKwRahi25Yj7A2M
	c/m6GDk5JARMJHbt38EKYYtJXLi3nq2LkYtDSGAZo0TDsaOsMEVt6xZBJRYxSpx7+psJwvnN
	KDFhwXOwKjYBNYkvXw6zg9giAp4SZ04uYAEpYhb4xSwx8eQnFri5F1YtAaviFNCUuPVrFROI
	LSwQLXHh4VU2EJtFQFVi4+1ljCA2r4CtxMtdU1ghbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95
	y9zFyAF0q7rEo7+6EEcYSXye8AaqXERi34t3jCA3SAjc4JA4+uMlE8QuAYlvkw+xQPTKSmw6
	wAzxsqTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UWGesWJucWleel6yfm5
	mxghKaV3B+PtA9aHGJOB1k9klhJNzgempLySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYExkvfBmcdrLR8nc4W5hYsebXjj+XiV4VumsCUvvCqWX
	aXeMLh5TCK2p3vX5Rdz6lLP3zl7fKdcge+HO4u0ll/gUYs5L3wp+ff/hK53t6hsVNjH+4DFU
	SHuvnR263ILNtyZzzr6wjE45hb3lGqYt4ZYiFXtvvvjGZt9f6OUxvbHod+qlSGO1NiWW4oxE
	Qy3mouJEABU1Fzc/AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42I5/e+xgO5xt+xgg+4dchZ/Jx1jt5g6eTub
	xZKmDIuXhzQt5h85x2pxeeElVovvN0wtLjztYbPY9Pgaq8XCtiUsFpd3zWGzmL2kn8Xi7Lzj
	bBZv2hoZLTZO/cVo0X5J2aLnkZbF7d98DkIev39NYvSYN+sEi8eCTaUem5fUe/Q2v2Pz+L6j
	l9Gjb8sqRo+nP/Yyexy/sZ3J4/MmuQCuqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygf5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGbs2H2Yp2CJUsW3LEfYGxrl8XYycHBICJhJt6xaxQdhiEhfurQeyuTiEBBYxSpx7
	+psJwvnNKDFhwXNWkCo2ATWJL18Os4PYIgKeEmdOLmABKWIW+MUsMfHkJxaIjmWMEhdWLQGr
	4hTQlLj1axUTiC0sEC1x4eFVsH0sAqoSG28vYwSxeQVsJV7umsIKYQtK/Jh8jwXEZhbQkli/
	8zgThC0vsXnNW+YuRg6gW9UlHv3VhTjCSOLzhDdQ5SIS+168Y5zAKDQLyaRZSCbNQjJpFpKW
	BYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCE9YzqR2MKxssDjEKcDAq8fBmOGcFC7Em
	lhVX5h5ilOBgVhLhTXPMDhbiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGAyzSuJNzQ2MTOy
	NDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxpVGZ2dcrL3CGcOqG7nUx/97
	X+b5a85yt886sMTzq6zI/NO97vSSV2Ln6/JqE00/S/iUu/Zt1tp8wFdgsupcDdUNa1u9726d
	Vs+6p/3eDe03p7hW+3zv+xwTIa/AftjW9s5bps83Tm3dc1JuqdHmXVX1L+p+VcgWMXYvmWg/
	c3V6Q3TZ671uFkosxRmJhlrMRcWJAEaF0DacAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 07, 2014 6:26 PM, Arnd Bergmann wrote:
> On Wednesday 07 May 2014 14:52:47 Kishon Vijay Abraham I wrote:
> > On Tuesday 06 May 2014 10:05 PM, Jason Gunthorpe wrote:
> > > On Tue, May 06, 2014 at 07:03:51PM +0530, Kishon Vijay Abraham I wrote:
> > >> +Example:
> > >> +pcie@51000000 {
> > >> +    compatible = "ti,dra7xx-pcie";
> > >> +    reg = <0x51002000 0x14c>, <0x51000000 0x2000>;
> > >> +    reg-names = "ti_conf", "rc_dbics";
> > >> +    interrupts = <0 232 0x4>, <0 233 0x4>;
> > >> +    #address-cells = >;
> > >> +    #size-cells = <2>;
> > >> +    device_type = "pci";
> > >> +    ti,device_type = >;
> > >> +    ranges = <0x00000800 0 0x20001000 0x20001000 0 0x00002000  /* Configuration Space */
> > >
> > > Configuration space should not show up in the ranges, please don't
> > > copy that mistake from other drivers, put it in reg.
> >
> > But then it needs pcie-designware.c to be modified and it will be breaking
> > other platforms no?
> 
> I think the pcie-designware driver should be changed to allow either way.
> Ideally we would deprecate the existing method in a way that for new front-ends
> it doesn't work, but the old front-ends can still deal with it but also work
> if you put it into the reg property.

(+cc Pratyush Anand, Thierry Reding)

Hi Arnd,

Thank you for your comment.
Do you mean the case of Tegra PCIe as below?

./arch/arm/boot/dts/tegra20.dts
	pcie-controller@80003000 {
		...
		reg = <0x80003000 0x00000800   /* PADS registers */
			 0x80003800 0x00000200   /* AFI registers */
			 0x90000000 0x10000000>; /* configuration space */
		...
		ranges = <0x82000000 0 0x80000000 0x80000000 0 0x00001000   /* port 0 registers */
			0x82000000 0 0x80001000 0x80001000 0 0x00001000   /* port 1 registers */
			0x81000000 0 0          0x82000000 0 0x00010000   /* downstream I/O */
			0x82000000 0 0xa0000000 0xa0000000 0 0x08000000   /* non-prefetchable memory */
			0xc2000000 0 0xa8000000 0xa8000000 0 0x18000000>; /* prefetchable memory */
		...

./drivers/pci/host/pci-tegra.c
	/* request configuration space, but remap later, on demand */
	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cs");
	...
	pcie->cs = devm_request_mem_region(pcie->dev, res->start,
						resource_size(res), res->name);


Best regards,
Jingoo Han


