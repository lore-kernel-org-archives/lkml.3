Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3FEL7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:59:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63696 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3FEL7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:59:41 -0400
X-AuditID: cbfee68f-b7f436d000000f81-0f-51af282c3f51
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1369144571-16901-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1369144571-16901-1-git-send-email-tobetter@gmail.com>
Subject: RE: [PATCH] ARM: dts: add max77686 node entry for ODROID-X
Date: Wed, 05 Jun 2013 20:59:40 +0900
Message-id: <08e501ce61e4$28978720$79c69560$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5WKvuYJY2O6liESliBdGYe5q+R1gLuPB3Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY10djfWBBns+ilhsenyN1eLyrjls
	Frcv81qcuv6ZzeLYjCWMFvser2F2YPNoae5h89g56y67x51re9g8Ni+p97hyoonV4/MmuQC2
	KC6blNSczLLUIn27BK6Mr0fWsBe0M1ec3LmAvYFxM1MXIyeHhICJxMIj25ghbDGJC/fWs3Ux
	cnEICSxjlOh6eJEdpujlluesEIlFjBL/3u1hh3D+MkrMe9vLClLFJqAhcfj9M7AOEQE1ica/
	nWAdzAJHGCWOHDjLApIQEnCS6Dh9E2g3BwengLPEzHs+IGFhIHNuy0OwOSwCqhJ95/8xgti8
	ArYSk3u3sELYghI/Jt8DG8MsoCWxfudxJghbXmLzmrfMICMlBNQlHv3VhTjBSOLqjo+MECUi
	EvtevGMEOUdC4C27xKFXbewQuwQkvk0+xALRKyux6QA0JCQlDq64wTKBUWIWks2zkGyehWTz
	LCQrFjCyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIid3+HYx3D1gfYkwGWj+RWUo0OR8Y
	+3kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJw0
	kfPzz89ZvG+12TiUdnAKNj6aOH2x+ddHwrLV5/q1PPT/VH2dv5avJCbzxMb3f82Dujf9fXru
	8JHmQIav0509Jrfoiqr+3bbj0uxTbBc1Hadp2b935VUVtWQunNJrNnPlNfm3Xzc2tW2xe/HT
	gC34iuuqJz6LnfouF8cdn2eUuY6vZHW9k7USS3FGoqEWc1FxIgCobZZ08wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAV0djfWBBruaBC02Pb7GanF51xw2
	i9uXeS1OXf/MZnFsxhJGi32P1zA7sHm0NPeweeycdZfd4861PWwem5fUe1w50cTq8XmTXABb
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjK9H1rAXtDNXnNy5gL2BcTNT
	FyMnh4SAicTLLc9ZIWwxiQv31rN1MXJxCAksYpT4924PO4Tzl1Fi3ttesCo2AQ2Jw++fsYPY
	IgJqEo1/O1lBipgFjjBKHDlwlgUkISTgJNFx+ibQCg4OTgFniZn3fEDCwkDm3JaHYHNYBFQl
	+s7/YwSxeQVsJSb3bmGFsAUlfky+BzaGWUBLYv3O40wQtrzE5jVvmUFGSgioSzz6qwtxgpHE
	1R0fGSFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl
	5+duYgQnhmdSOxhXNlgcYhTgYFTi4f3AsC5QiDWxrLgy9xCjBAezkgjvpd9AId6UxMqq1KL8
	+KLSnNTiQ4zJQI9OZJYSTc4HJq28knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqem
	FqQWwWxh4uCUamDsyGVgn8srsf95a3Bgnve9Kc/N//eEn+NYbpm1THF9UdjNGczR7RVdiSle
	NxO+v+v8qSy1UEOm9rwHy5tr159k5N6uaWEWPGPacZf324nqgjL7JaZOkroNZ7kCyrS9N/Nv
	/ClrF+moGSXh/XaNqeKTF/EHxFks3yTNlLzMdX3j6WufXzxt36TEUpyRaKjFXFScCAAoqllI
	UAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongjin Kim wrote:
> 
> ODROID-X board have a max77686 PMIC on i2c channel 0. The properties of
> used
> LDO and BUCK are defined according the schematic.
> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4412-odroidx.dts |  195
> ++++++++++++++++++++++++++++++
>  1 file changed, 195 insertions(+)
> 

OK, applied.

Thanks.

- Kukjin

