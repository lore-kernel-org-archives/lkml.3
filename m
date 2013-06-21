Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423161Ab3FUEie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:38:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8989 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161292Ab3FUEic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:38:32 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-9d-51c3d8c60ac8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>
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
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, Jingoo Han <jg1.han@samsung.com>
References: <002001ce6e2e$623d7970$26b86c50$@samsung.com>
 <51C3D517.1080301@st.com>
In-reply-to: <51C3D517.1080301@st.com>
Subject: Re: [PATCH V9 1/4] pci: Add PCIe driver for Samsung Exynos
Date: Fri, 21 Jun 2013 13:38:29 +0900
Message-id: <003601ce6e39$2dd30b40$897921c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHEv9aFH+pKaZxyX6AneK9Zg3eF6wIOWxPfmUJ/EvA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t8zfd1jNw4HGnx+rGTR/H87q8XfScfY
	LZY0ZVi8PKRpcWD2Q1aLV2c2sllcXniJ1eL7DVOL3gVX2Sw2Pb7GanF51xw2i7PzjrNZzDi/
	j8li49RfjBbtl5QtVjRtZbRYfHE5s8X6Ga9ZLHavXMJicWzGEkaLpw+amBxEPdbMW8Po8fvX
	JEaPvilX2TyebLrI6LFgU6nHnWt72Dw2L6n3OD9jIaPH9x29QAVbVjF6/Hyp4/H0x15mj8+b
	5AJ4o7hsUlJzMstSi/TtErgyFlx/wlzwmqVixdlO5gbG18xdjJwcEgImEsuuzmWDsMUkLtxb
	D2RzcQgJLGOUePtsBStM0dfmZSwQiUWMEsvfv2WFcH4xSqzedYQJpIpNQE3iy5fD7CC2iICO
	xPEVS5lBipgF1rNJPL/RAlYkJBAqcXrWIaAEBwcnUMPbn84gYWEBZ4nfa7+AbWMRUJX4uKEP
	zOYVsJTYN7edEcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrdQ7yhI7Dj7mhHiBiuJe9+3MEPU
	iEjse/GOEeQeCYFmTokJx35BLROQ+Db5EAvIPRICshKbDkDNkZQ4uOIGywRGiVlIVs9CsnoW
	ktWzkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkHU3YwXjvgPUhxmSg9ROZpUST
	84HpLK8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jIvkF1533/1lhfPtozkHV9YduVe0ISpXxFta9Mz2Sas7uxd8NTe5L3Y0ueZcpb7a6arKRR8i
	n6id7thr0lkxt/FNsVnVQbO+V2JfGb/G7RVflcl50KLh4KlPE3l8G5sjWP/uzuflic6+k1/f
	GPmVkdV86V//kkcp/6cwP6x1uJD3NV7eQNfpsRJLcUaioRZzUXEiACcq5iZdAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsVy+t9jAd1jNw4HGhzdJ2PR/H87q8XfScfY
	LZY0ZVi8PKRpcWD2Q1aLV2c2sllcXniJ1eL7DVOL3gVX2Sw2Pb7GanF51xw2i7PzjrNZzDi/
	j8li49RfjBbtl5QtVjRtZbRYfHE5s8X6Ga9ZLHavXMJicWzGEkaLpw+amBxEPdbMW8Po8fvX
	JEaPvilX2TyebLrI6LFgU6nHnWt72Dw2L6n3OD9jIaPH9x29QAVbVjF6/Hyp4/H0x15mj8+b
	5AJ4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	3lVSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZiy4/oS54DVLxYqzncwN
	jK+Zuxg5OSQETCS+Ni9jgbDFJC7cW8/WxcjFISSwiFFi+fu3rBDOL0aJ1buOMIFUsQmoSXz5
	cpgdxBYR0JE4vmIpM0gRs8B6NonnN1rAioQEQiVOzzoElODg4ARqePvTGSQsLOAs8XvtF1YQ
	m0VAVeLjhj4wm1fAUmLf3HZGCFtQ4sfke2AXMQtoSazfeZwJwpaX2LzmLdTVChI7zr5mhLjB
	SuLe9y3MEDUiEvtevGOcwCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS
	9ZLzczcxgpPdM+kdjKsaLA4xCnAwKvHwBigdDhRiTSwrrsw9xCjBwawkwis2ESjEm5JYWZVa
	lB9fVJqTWnyIMRno04nMUqLJ+cBEnFcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs
	1NSC1CKYLUwcnFINjBNC10r23ZV7oGAU6OQQ5tS7+861tnDfe9dDZWQYlOUnXlZXiH1/J2n6
	xU+X1y5Z+uTaPsUizeTo+Gtv+Bfq/wg4fFxx8l2l+oNx/Pxzcthd9p7+6Xj2rt/OBBHe8LNe
	B+SjCnS5tZ7tKAjUWBEdsNVBMTf7d9pC+ZC9qw7qhn+wtDmqdmrBFCWW4oxEQy3mouJEAOJU
	j1W6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 21, 2013 1:23 PM, Pratyush Anand wrote:
> On 6/21/2013 8:51 AM, Jingoo Han wrote:
> > diff --git a/drivers/pci/host/pci-designware.c b/drivers/pci/host/pci-designware.c
> > new file mode 100644
> > index 0000000..f8558ff
> > --- /dev/null
> > +++ b/drivers/pci/host/pci-designware.c
> 
> If you plan to send next version, then I would suggest to rename it as
> pcie-designware.c, because synopsis pcie and pci controllers are different.

OK, I see.
I rename it as 'pcie-designware.c'.
Thank you for your suggestion. :)

Best regards,
Jingoo Han

> 
> Regards
> Pratyush
> 
> 


