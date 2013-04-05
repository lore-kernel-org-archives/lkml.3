Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161625Ab3DEGu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:50:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36399 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3DEGuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:50:24 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-e9-515e7411da05
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        "'Heiko Stuebner'" <heiko@sntech.de>
References: <20130405160256.7ca6f52e25e0d2231eb1fcfe@canb.auug.org.au>
In-reply-to: <20130405160256.7ca6f52e25e0d2231eb1fcfe@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the samsung tree with the arm-soc tree
Date: Fri, 05 Apr 2013 15:49:53 +0900
Message-id: <2a5a01ce31c9$c7051670$550f4350$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xut9H6d437KlYQ8yTuQ5hEvXTugADsrBA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zI13BkrhAgwurLSz+TjrGbvF+WQ+j
	xf9Hr1ktNj2+xmpxedccNouDC9sYLU5d/8xmsXXvVXYHDo8189Ywevz+NYnRo/HGDTaPzUvq
	Pa6caGL12H5tHrPH501yAexRXDYpqTmZZalF+nYJXBmf9s9mKljOUjF95X+2BsYdzF2MnBwS
	AiYSn94sYoWwxSQu3FvP1sXIxSEksIxR4nvHbFaYogPvW5khEtMZJXon7WeBcP4yShxu/Qk2
	ik1AQ+Lw+2fsILaIgK5E37/5TCBFzCBFTZeXgiWEBNwkNl28wgRicwq4S+x7eYsFxBYW8Jfo
	f/QZLM4ioCqx9d0VsKG8ArYS2ztfsEDYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe8xaongPoVHWJ
	R391IW4wkvh16gAzRImIxL4X7xhB7pEQ+MsusfDpYahdAhLfJh9igeiVldh0ABoskhIHV9xg
	mcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoREd/8OxrsH
	rA8xJgOtn8gsJZqcD0wOeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUX
	leakFh9iZOLglGpgXKkowBgmrqUbGGsupMuVKh38/mPs15bLE1b277SWj10f+VPspLJphLui
	8pPrO6bpT8jrOLjhFpeMbN2iwMjoE/Nfr3LdFdZ080TKnujzXuvM9ys/Zmg88ulp/v2Gxc/N
	U87a1LomuS9vXLM9zLUuNOfNg8I53ys2xO9f/rAzNmzxAs5K362VSizFGYmGWsxFxYkASti+
	GgQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jQV3BkrhAgy09xhZ/Jx1jt3i/rIfR
	4v+j16wWmx5fY7W4vGsOm8XBhW2MFqeuf2az2Lr3KrsDh8eaeWsYPX7/msTo0XjjBpvH5iX1
	HldONLF6bL82j9nj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ
	n/bPZipYzlIxfeV/tgbGHcxdjJwcEgImEgfet0LZYhIX7q1n62Lk4hASmM4o0TtpPwuE85dR
	4nDrT7AqNgENicPvn7GD2CICuhJ9/+YzgRQxgxQ1XV4KlhAScJPYdPEKE4jNKeAuse/lLRYQ
	W1jAX6L/0WewOIuAqsTWd1fAhvIK2Eps73zBAmELSvyYfA/MZhbQkli/8zgThC0vsXnNW6B6
	DqBT1SUe/dWFuMFI4tepA8wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT
	0nMN9YoTc4tL89L1kvNzNzGCU8czqR2MKxssDjEKcDAq8fBm9MUGCrEmlhVX5h5ilOBgVhLh
	3ckXFyjEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cC0llcSb2hsYmZkaWRmYWRibk6asJI4
	74FW60AhgfTEktTs1NSC1CKYLUwcnFINjN4vpr7Rfn3N86fGvzeCdxdp98b0HV+TZTNzgcCx
	1YEqMYLWDR32RSwWZau8/dKqixsW87DvXGcZ3ZvX09bi9zuy53QQa7n7yRlHv7yKf3ntrKRk
	1b6JfCuExAr2G21ebPn5i3VdbnXYgmeZbNcPWWraTHnyaPGSQFt1V6/tZinVG2tkOG2/K7EU
	ZyQaajEXFScCAH53+iRhAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
Hi,

> Today's linux-next merge of the samsung tree got a conflict in
> drivers/irqchip/irq-s3c24xx.c between commit de88cbb7b244 ("arm: Move
> chained_irq_(enter|exit) to a generic file") from the arm-soc tree (where
> it is called arch/arm/mach-s3c24xx/irq.c) and commit f0774d41da0e
> ("irqchip: s3c24xx: add devicetree support") from the samsung tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
Looks good to me, thanks.

- Kukjin

