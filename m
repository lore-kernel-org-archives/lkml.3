Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbaCLIlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 04:41:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47814 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbaCLIlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 04:41:37 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-12-53201dbd13ef
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liviu Dudau'" <Liviu.Dudau@arm.com>
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1394020150-1875-1-git-send-email-Liviu.Dudau@arm.com>
 <1394020150-1875-4-git-send-email-Liviu.Dudau@arm.com>
In-reply-to: <1394020150-1875-4-git-send-email-Liviu.Dudau@arm.com>
Subject: Re: [PATCH v6 3/3] arm64: Add architecture support for PCI
Date: Wed, 12 Mar 2014 17:41:33 +0900
Message-id: <000101cf3dce$df2c1840$9d8448c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac84aTR3ZMLSvog0RG6rj7hrOp2f3wFZMxXQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zI929sgrBBj9XyFv8nXSM3eJDUyuz
	xZKmDIv3y3oYLeYfOcdqcXnhJVaL94eeMVtsenwNyN01h83i7LzjbBYHlrazWDz/9InF4uXH
	EywOvB4f139i9Fgzbw2jx+9fkxg9Fmwq9eh508LqsXlJvcftf4+ZPfq2rGL0+LxJLoAzissm
	JTUnsyy1SN8ugSvjcNciloJJvBUXrr9ib2CcztXFyMkhIWAi8Wz6fCYIW0ziwr31bF2MXBxC
	AssYJWZeW8vSxcgBVrTpsQNEfDqjxLJbi5ggnN+MEv+ePmUH6WYTUJP48uUwmC0ioC5x98kx
	FpAiZoFfzBIdB7eArRASqJZ4PX8jM4jNKeAs8WDSLVYQWxjI7njaAmazCKhK7PiwA6yGV8BW
	YkJ3DwuELSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZIS5Vl3j0VxfiBiOJ3d/3M0OUiEjse/GO
	EeQeCYEtHBILT/9jhNglIPFt8iGoL2UlNh1ghoSEpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUC
	RpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCHJYeIOxvsHrA8xJgOtn8gsJZqcD0wueSXx
	hsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaD5ddd7v
	ixvblVJ210yJFHobWhad+8aT7dCjz41L1S5/nRK/uEry1xXVeX8NP67XbI66KrzGJ6sgNIH5
	v3nyEaYHW9IiJkz4WVMocUzALemT56SHC5T22DWoHnWarrNUqrBf12Tt9sw1uSGH7BYzvlvY
	Lvfi2lnPnfoHfNjyy7c+Udm0KHVFphJLcUaioRZzUXEiAGpyFa4kAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t9jQd29sgrBBhsmSVn8nXSM3eJDUyuz
	xZKmDIv3y3oYLeYfOcdqcXnhJVaL94eeMVtsenwNyN01h83i7LzjbBYHlrazWDz/9InF4uXH
	EywOvB4f139i9Fgzbw2jx+9fkxg9Fmwq9eh508LqsXlJvcftf4+ZPfq2rGL0+LxJLoAzqoHR
	JiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfobCWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxuGuRSwFk3grLlx/xd7AOJ2ri5GD
	Q0LARGLTY4cuRk4gU0ziwr31bF2MXBxCAtMZJZbdWsQE4fxmlPj39Ck7SBWbgJrEly+HwWwR
	AXWJu0+OsYAUMQv8YpboOLiFCSQhJFAt8Xr+RmYQm1PAWeLBpFusILYwkN3xtAXMZhFQldjx
	YQdYDa+ArcSE7h4WCFtQ4sfke2A2s4CWxPqdx5kgbHmJzWveMkNcrS7x6K8uxA1GEru/72eG
	KBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	nHqeSe1gXNlgcYhRgINRiYd3gaZ8sBBrYllxZe4hRgkOZiURXiERhWAh3pTEyqrUovz4otKc
	1OJDjMlAj05klhJNzgemxbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbB
	bGHi4JRqYJT+uU+xarVKitvRWIlQ0483H3av7ApxK96/juFKQs2Pj3y7Mmt+6Ky4t3+LjGBI
	aq1Ejeqzlth3ehrnpv/IuqEjN2PeuuhP5Y+t5uRPWNiROu3g8gmPfspx/zzncyzecd6er+F1
	H+KNA/KuaN4L51xxUinw6upH044v6794Y3XT7btbiiOnnjFSYinOSDTUYi4qTgQAZPZb14ED	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 8:49 PM, Liviu Dudau wrote:
> 
> Use the generic host bridge functions to provide support for
> PCI Express on arm64. There is no support for ISA memory.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  arch/arm64/Kconfig            |  19 +++-
>  arch/arm64/include/asm/Kbuild |   1 +
>  arch/arm64/include/asm/io.h   |   3 +-
>  arch/arm64/include/asm/pci.h  |  49 +++++++++
>  arch/arm64/kernel/Makefile    |   1 +
>  arch/arm64/kernel/pci.c       | 173 ++++++++++++++++++++++++++++++++
>  6 files changed, 244 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/include/asm/pci.h
>  create mode 100644 arch/arm64/kernel/pci.c

[.....]

> --- /dev/null
> +++ b/arch/arm64/include/asm/pci.h

[.....]

> +
> +static inline int pci_domain_nr(struct pci_bus *bus)
> +{
> +	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
> +
> +	if (bridge)
> +		return bridge->domain_nr;
> +
> +	return 0;
> +}

Hi Liviu Dudau,

When CONFIG_PCI=n, the following build errors happen. :-(
Would you confirm this?

In file included from include/linux/pci.h:1393:0,
                 from drivers/scsi/scsi_lib.c:19:
arch/arm64/include/asm/pci.h:31:19: error: redefinition of 'pci_domain_nr'
 static inline int pci_domain_nr(struct pci_bus *bus)
                   ^
In file included from drivers/scsi/scsi_lib.c:19:0:
include/linux/pci.h:1383:19: note: previous definition of 'pci_domain_nr' was here
 static inline int pci_domain_nr(struct pci_bus *bus) { return 0; }
                   ^
             .....

Best regards,
Jingoo Han

