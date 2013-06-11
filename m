Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3FKGAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:00:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18532 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3FKGA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:00:27 -0400
X-AuditID: cbfee68e-b7f276d000002279-db-51b6bcf97c6c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
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
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <201306071943.18407.arnd@arndb.de>
 <000001ce65b5$e45477f0$acfd67d0$@samsung.com>
 <201306101722.10146.arnd@arndb.de>
In-reply-to: <201306101722.10146.arnd@arndb.de>
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Tue, 11 Jun 2013 15:00:25 +0900
Message-id: <002e01ce6668$f785dc20$e6919460$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFyr6c5AKxr6zs5JXOh3KubdCPksAHFjqq9AWqMh6UBHmRjK5nE/Hxw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t8zfd1fe7YFGhzvZrJo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJWxoXU3W8Fj
	noq1i/tZGhgvcnYxcnJICJhIdO+6yARhi0lcuLeerYuRi0NIYBmjxO25C5hhio6tO8oKYgsJ
	TGeU6FlWClH0i1Hi35JVYEVsAmoSX74cZgexRQSUJY6/vMMCUsQscIhVYs/6DawQHdsZJZpb
	PgI5HBycAvoSL+/LgjQIC0RIXHn+GOwMFgFVibaD58G28QpYSrzbf4AJwhaU+DH5HguIzSyg
	JbF+53EmCFteYvOat1CXKkjsOPuaEeIIN4mJ784zQtSISOx78Y4R5AYJgSccEpMaPjJDLBOQ
	+Db5EAvIPRICshKbDkDNkZQ4uOIGywRGiVlIVs9CsnoWktWzkKxYwMiyilE0tSC5oDgpvchI
	rzgxt7g0L10vOT93EyMkwfTtYLx5wPoQYzLQ+onMUqLJ+cAElVcSb2hsZmRhamJqbGRuaUaa
	sJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxlb1iQcalb9/qeqbIsCU51/GJDZt
	t6eyQNmG5H/y1VbujeH37a+1yUdn3ZBStT2pu5tvVjP7CevsEl6vDBGb1Ue+Vi/47nxX6vta
	xQ0/3xfFOTm+7zzdFePdmC5/w/xkgvWTNT8brVlD//8LiE7e6idic/zVdLm6OVoSd4/fZDjx
	aGKR6+rbSizFGYmGWsxFxYkAR1T3vUYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsVy+t9jQd2fe7YFGhxbamHR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoLyWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxobW3WwFj3kq1i7uZ2lgvMjZxcjJISFgInFs3VFWCFtM4sK99Wwg
	tpDAdEaJnmWlXYxcQPYvRol/S1YxgyTYBNQkvnw5zA5iiwgoSxx/eYcFpIhZ4BCrxJ71G1gh
	OrYzSjS3fARyODg4BfQlXt6XBWkQFoiQuPL8MROIzSKgKtF28DzYZl4BS4l3+w8wQdiCEj8m
	32MBsZkFtCTW7zzOBGHLS2xe85YZ4lIFiR1nXzNCHOEmMfHdeUaIGhGJfS/eMU5gFJqFZNQs
	JKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB6euZ9A7GVQ0WhxgFOBiV
	eHgTGLcFCrEmlhVX5h5ilOBgVhLhNd0OFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YGrN
	K4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGkee+G60TJzif
	fNdUVtTzP+DsMSnrZVdSpsRnql0s/f3xlsZSHc5ns2ZYH7lmn5lj9IBxm5rrjnWKrL5iRllm
	xis+icXcb6r7fczeT3tOkl7j3hfrTJXceQMX8Fw6yZ3A9H6Z2ine2ZpzF//eO+/RdUkRsfXh
	k20N5rrMnWztdjTsus4Gnc2nlViKMxINtZiLihMBf1sWbaMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 11, 2013 12:22 AM, Arnd Bergmann wrote:
> On Monday 10 June 2013, Jingoo Han wrote:
> > On Saturday, June 08, 2013 2:43 AM, Arnd Bergmann wrote:
> > For multiple domains, how can I fix the DT properties?
> 
> Domains are a Linux concept, you have to pick a new domain number for each
> struct hw_pci you register.

Hi Arnd,

Thank you for your reply.
It is very helpful. :)

I will set domain numbers for each struct hw_pci.

> 
> > Current DT properties are as below:
> >
> > +	pcie0@40000000 {
> > +		compatible = "samsung,exynos5440-pcie";
> > +		reg = <0x40000000 0x4000
> > +			0x290000 0x1000
> > +			0x270000 0x1000
> > +			0x271000 0x40>;
> > +		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
> > +		#address-cells = <3>;
> > +		#size-cells = <2>;
> > +		device_type = "pci";
> > +		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> > +			  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
> > +			  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
> > +	};
> 
> An unrelated comment: your first "reg" field seems to overlap with part
> of your configuration space. Is that intentional?

Yes, intentional.
But, I will try to remove it.

> 
> Also, shouldn't your memory space end on a 256MB boundary, rather than
> extend up to 0x50203fff?

According to the manual of Exynos PCIe, each memory space for Exynos PCIe
can support 512MB, including I/O, CFG regions.

Is there any problem when over 256MB boundary is used?
Please let me know. :)


Best regards,
Jingoo Han

> 
> 	Arnd

