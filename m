Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3H2EnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:43:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40649 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3H2EnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:43:03 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-3d-521ed154f3c6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003d01ce9fc6$9c0f1c20$d42d5460$%han@samsung.com>
 <20130823083539.GB3937@pratyush-vbox>
 <001801cea3c7$06bca9d0$1435fd70$%han@samsung.com>
 <20130829034508.GA3025@pratyush-vbox>
In-reply-to: <20130829034508.GA3025@pratyush-vbox>
Subject: Re: [PATCH V2] PCI: exynos: add support for MSI
Date: Thu, 29 Aug 2013 13:43:00 +0900
Message-id: <003001cea472$3d6ffee0$b84ffca0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6kajhlI5L605tNRNK/Xp5t9R2jTwABoqDQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zA92Qi3JBBjN3W1n8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLFU1b
	GS1+7prHYvH0QROTRePRB6wWrU8eMDoIevz+NYnR48mmi4weO2fdZfdYsKnU4/vC+ewefVtW
	MXo8/bGX2eP4je1MHp83yQVwRnHZpKTmZJalFunbJXBl/Jw+jb1gH0fFitYnLA2MO9m6GDk4
	JARMJPbO0uli5AQyxSQu3FsPFObiEBJYxigxefoORoiEicSBQ68YIRLTGSV6u74zQTi/GCX6
	/09nAqliE1CT+PLlMDuILSKgI3F8xVJmkCJmgfssEge+roHqOMgoseHbErAOTgEjicWbNoB1
	CAtYSJxtvMQGYrMIqEr83foAbDevgK3E1bPHWSBsQYkfk++B2cwCWhKbtzWxQtjyEpvXvGWG
	+Edd4tFfXYgjjCSOv3rGBlEiIrHvxTuwFyQEznBInOq4wwSxS0Di2+RDLBC9shKbDjBDvCwp
	cXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSBKZ
	uIPx/gHrQ4zJQOsnMkuJJucDk1BeSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhhFmV3+a0YkSzQaN7NWXvize8oBw98fdpb+ummSsjFay/HZzfSD
	M63XqglFtnzl4r0/veO04u62tefSBJV/swR8tZS5wWNVxGSxemOHUIRxRupTdhcXzngmqVfc
	+zw3aPxNO3+QJ+myQnMin9atUlsZVbWmPPfoiNXftDbtu3WgRO/W3QzfZUosxRmJhlrMRcWJ
	ABrrSPw4AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e+xoG7IRbkgg6YVJhZ/Jx1jt1jSlGHx
	8pCmxfwj51gtLi+8xGrRu+Aqm8WFpz1sFpd3zWGzODvvOJvFjPP7mCw2Tv3FaNF+SdliRdNW
	Roufu+axWDx90MRk0Xj0AatF65MHjA6CHr9/TWL0eLLpIqPHzll32T0WbCr1+L5wPrtH35ZV
	jB5Pf+xl9jh+YzuTx+dNcgGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAnygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesY
	M35On8ZesI+jYkXrE5YGxp1sXYycHBICJhIHDr1ihLDFJC7cWw8U5+IQEpjOKNHb9Z0JwvnF
	KNH/fzoTSBWbgJrEly+H2UFsEQEdieMrljKDFDEL3GeROPB1DVTHQUaJDd+WgHVwChhJLN60
	AaxDWMBC4mzjJbDdLAKqEn+3PgDbzStgK3H17HEWCFtQ4sfke2A2s4CWxOZtTawQtrzE5jVv
	gbZxAN2qLvHory7EEUYSx189Y4MoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBc
	UJyUnmukV5yYW1yal66XnJ+7iRGcpJ5J72Bc1WBxiFGAg1GJhzfit2yQEGtiWXFl7iFGCQ5m
	JRHeU/vkgoR4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5hA80riDY1NzIwsjcwsjEzMzUkT
	VhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcfKD+ZMmFMhGPLaLuzPPq5RnzYlDG9zTd9yV
	mCUSqn5p4s7iDU5/pTO37eg8d5CDY9+Xg0e31axM2tDYpCh19JjbsuP1VtoCEqG+nJP2BJ4q
	t8m8dz9iHY9E8ZbHk/9z2pyyfbcx4pLuG/U+ldN8hjUmWXyv//boW9l33m7W1Lyc1lAs/s2/
	RomlOCPRUIu5qDgRAEnqleiWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 29, 2013 12:45 PM, Pratyush Anand wrote:
> On Wed, Aug 28, 2013 at 04:17:24PM +0800, Jingoo Han wrote:
> > On Friday, August 23, 2013 5:36 PM, Pratyush Anand wrote:
> > > On Fri, Aug 23, 2013 at 02:04:20PM +0800, Jingoo Han wrote:
> >
> 
> [...]
> 
> > > #define MAX_PCIE_PORT_SUPPORTED 3
> > > static DECLARE_BITMAP(msi_irq_in_use[MAX_PCIE_PORT_SUPPORTED],
> > >                   NUM_MSI_IRQS);
> > > static unsigned int *msi_data[MAX_PCIE_PORT_SUPPORTED];
> >
> > No, there is no need to do it.
> > Without this, we can use 3 RCs by adding a node of 3rd RC to dt file.
> >
> 
> Yes, you can use RCs by adding nodes to dt file. But you will need one
> msi_irq_in_use and one msi_data per RC (ie per port in this driver), isn't it?

Aha, you're right.

A few minutes ago, I found the same value of msi_data is
used for 2 different RCs. It is my fault.

As you mentioned, one msi_data per RC should be used.
I will modify it in order to use one msi_data per RC.

Thank you for your kind description. :-)

Best regards,
Jingoo Han


