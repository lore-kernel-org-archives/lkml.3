Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965406AbaFRJ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:27:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28740 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964994AbaFRJ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:27:08 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-d7-53a15b69fad3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tony@atomide.com,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Mohit Kumar'" <mohit.kumar@st.com>, "'Marek Vasut'" <marex@denx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
 <1401345500-20188-4-git-send-email-kishon@ti.com> <53876116.90504@ti.com>
 <3E54258959B69E4282D79E01AB1F32B70477D2A4@DFLE11.ent.ti.com>
 <53A15879.7030302@ti.com>
In-reply-to: <53A15879.7030302@ti.com>
Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should be
 specified in 'reg'
Date: Wed, 18 Jun 2014 18:27:05 +0900
Message-id: <000001cf8ad7$784e1aa0$68ea4fe0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+K1drEdbSDWJPdRl6SZRW9YZAtBwAALIMg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t8zfd3M6IXBBhuO2Fj8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqvF9xumFhee9rBZbHp8jdViYdsSFovLu+awWcxe0s9icXbecTaLvt4D
	bBZv2hoZLTZO/cVosf+Kl4OAx+9fkxg9vn2dxOIxb9YJFo8Fm0o9Ni+p9/i+o5fRo2/LKkaP
	pz/2Mnscv7GdyePzJrkArigum5TUnMyy1CJ9uwSujIYJhgWH+Ctm3VJqYDzC08XIySEhYCJx
	asc3NghbTOLCvfVANheHkMAyRoldD5tZYYr2vv8OlVjEKHH663dmCOc3o8Tet0vYQarYBNQk
	vnw5zA6SEBFoYZQ48/o7I4jDLLCIWeLo/y8sEC1PGCXOvfrDBNLCCdTy6dZXsCXCAokSvy71
	Ai1h52ARUJXoFwWJ8grYSvx5v4gJwhaU+DH5HguIzSygJbF+53EmCFteYvOat0AXcQCdqi7x
	6K8uSFhEwEhi6vwFUCUiEvtevAM7R0LgAofEhYknwY5mERCQ+Db5EAtEr6zEpgPMEB9LShxc
	cYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJEZI8+nYw
	3jxgfYgxGWj9RGYp0eR8YPLJK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2M644+Viw15AuolVp2tNlJ/F7eVtEsk+AHTN7P9ph8Wc9tmx+ksifu
	88zbPnY9G2anbYqQNgw+udR1Zfz+tJSX+s0rZ/Elb5rEEcmtmVew1XOPHsfZld/v7eYV9Pmf
	fTX070GxqXM5961P4whgEnp7QjSVTX72n72ue/emBT+LusTkompTHdGtxFKckWioxVxUnAgA
	UUBgvzQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t9jAd3M6IXBBq2HzSz+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idXi+w1TiwtPe9gsNj2+xmqxsG0Ji8XlXXPYLGYv6WexODvvOJtFX+8B
	Nos3bY2MFhun/mK02H/Fy0HA4/evSYwe375OYvGYN+sEi8eCTaUem5fUe3zf0cvo0bdlFaPH
	0x97mT2O39jO5PF5k1wAV1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0B9KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyG
	CYYFh/grZt1SamA8wtPFyMkhIWAisff9dzYIW0ziwr31QDYXh5DAIkaJ01+/M0M4vxkl9r5d
	wg5SxSagJvHly2F2kISIQAujxJnX3xlBHGaBRcwSR/9/YYFoecIoce7VHyaQFk6glk+3vrKC
	2MICiRK/LvUCLWHnYBFQlegXBYnyCthK/Hm/iAnCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3
	QBdxAJ2qLvHory5IWETASGLq/AVQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuS
	C4qT0nON9IoTc4tL89L1kvNzNzGCU9Mz6R2MqxosDjEKcDAq8fBy5C4IFmJNLCuuzD3EKMHB
	rCTCO8VzYbAQb0piZVVqUX58UWlOavEhxmSgNycyS4km5wPTZl5JvKGxiZmRpZGZhZGJuTlp
	wkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MMp/NDVPe7KjYMYhT7P4llN1Buu1b27lWfgz
	aq3tlj2Cu2Pzry/6ovvcxNFMgN8tZXb15DmBmXszC+9//r7l4ZzlBWZXRatz9eavWLShbc+j
	NVJ3XeOSw25WKC14+Pm8xu84dslkiXdphqqztb83fmQpl4jO/v/wY5asnfwnqa4Ppp4aNr9O
	JiqxFGckGmoxFxUnAgB0rb5PkQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 18, 2014 6:15 PM, Kishon Vijay Abraham I wrote:
> On Friday 30 May 2014 07:45 PM, Karicheri, Muralidharan wrote:
> >> On 5/29/2014 2:38 AM, ABRAHAM, KISHON VIJAY wrote:
> >>> The configuration address space has so far been specified in *ranges*,
> >>> however it should be specified in *reg* making it a platform MEM resource.
> >>> Hence used 'platform_get_resource_*' API to get configuration address
> >>> space in the designware driver.
> >>>
> >>> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> >>> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >>> Cc: Mohit Kumar <mohit.kumar@st.com>
> >>> Cc: Jingoo Han <jg1.han@samsung.com>
> >>> Cc: Marek Vasut <marex@denx.de>
> >>> Cc: Arnd Bergmann <arnd@arndb.de>
> >>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>> ---
> >>>   .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
> >>>   drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
> >>>   2 files changed, 16 insertions(+), 2 deletions(-)

[...]

> >>> +	cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
> >>> +	if (cfg_res) {
> >>> +		pp->config.cfg0_size = resource_size(cfg_res)/2;
> >>> +		pp->config.cfg1_size = resource_size(cfg_res)/2;
> >>> +		pp->cfg0_base = cfg_res->start;
> >>> +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
> >>> +	} else {
> >>> +		dev_err(pp->dev, "missing *config* reg space\n");
> >> This should return error -EINVAL.
> 
> Just read the other thread and Grant Likely suggested the host controller
> driver should be backward compatible [1]. So we can't return -EINVAL here.
> So I'd assume this patch is fine as is? Arnd? Jingoo?

Yes, you're right. The driver should keep backward compatibility for
legacy DT binding. However, after enough time goes by, these legacy
DT handling can be removed.

Best regards,
Jingoo Han

> 
> [1] -> https://lkml.org/lkml/2014/6/3/124
> 
> Thanks
> Kishon

