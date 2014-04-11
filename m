Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaDKCDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:03:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35594 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaDKCDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:03:18 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-d2-53474d650138
Message-id: <53474D66.7020605@samsung.com>
Date: Fri, 11 Apr 2014 11:03:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        yj44.cho@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/27] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-4-git-send-email-cw00.choi@samsung.com>
 <20140411014858.GC14934@quad.lixom.net>
In-reply-to: <20140411014858.GC14934@quad.lixom.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkQDfV1z3YoG+9sMXnDy3sFpPuT2Cx
	6F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWp65/BrImv2SzWD/jNYvF3p2TGR24PTYvqfe4
	cqKJ1aNvyypGj8+b5AJYorhsUlJzMstSi/TtErgynhx9yVwwk6Xi1cZWpgbGTcxdjJwcEgIm
	EttbG9khbDGJC/fWs3UxcnEICSxllJiy+StjFyMHWFFPZzBEfDqjxP2vTawQzmtGie9zXrGB
	dPMKaEk0n5vPCmKzCKhK7F71EsxmA4rvf3EDrEZUIExi5fQrLBD1ghI/Jt8Ds0UElCWetF1i
	BhnKLDCFSWLhtD9gzcICPhJ3r54FO09IYDWjxIXvmiA2J9BFs7b0M4HYzAI6Evtbp7FB2PIS
	m9e8BRskIfCSXaJt/SMWiIsEJL5NPsQC8Y6sxKYDUO9LShxccYNlAqPYLCQ3zUIydhaSsQsY
	mVcxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBEbl6X/Pencw3j5gfYgxGWjlRGYp0eR8YFTn
	lcQbGpsZWZiamBobmVuakSasJM6b9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj6BbV
	fTxP7wv8K+t967nKY7vBtevPtp6XdFvg8vnW95w71U93si6w/ldrlHRBdcnOhqBskwuff9xa
	YPFp3USFct1QKx8WxfuXPv7aubBRLf6Jz9H2V5eFmGJFY834VuR28p2unK83ufRRRG6USdZ3
	qfyZpada2MRWP5pafG/ygikWR75//BF7W4mlOCPRUIu5qDgRADEh99bgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd1UX/dggx93uC0+f2hht5h0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyOHX9M5A1+SWbxfoZr1ks9u6czOjA7bF5Sb3H
	lRNNrB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCX
	mJtqq+TiE6DrlpkDdJWSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePJ
	0ZfMBTNZKl5tbGVqYNzE3MXIwSEhYCLR0xncxcgJZIpJXLi3nq2LkYtDSGA6o8T9r02sEM5r
	Ronvc16xgVTxCmhJNJ+bzwpiswioSuxe9RLMZgOK739xA6xGVCBMYuX0KywQ9YISPybfA7NF
	BJQlnrRdYgYZyiwwhUli4bQ/YM3CAj4Sd6+eZQexhQRWM0pc+K4JYnMCXTdrSz8TiM0soCOx
	v3UaG4QtL7F5zVvmCYwCs5DsmIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcx
	gmP+mfQOxlUNFocYBTgYlXh4D1xyCxZiTSwrrsw9xCjBwawkwtvzAyjEm5JYWZValB9fVJqT
	WnyIMRkYBBOZpUST84HpKK8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakFqUUw
	W5g4OKUaGO39Typ/Nn7v0jZB475v3JwqLQPvpxL3Tcufp7K1up+48jx+uXrj4se/9NgDS709
	GyZvjfVwKX/N0r32rVX3mQOfLl6KXS5jIWW9rFBgwfYrp083HL5+xzv337fUiX/EI+3iJt7Z
	6rBw+yLlQ0uVrh8u/fzC4P4JpVN39xRVLgnO2zrpeIlm6xYlluKMREMt5qLiRADsA8MWPQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 10:48 AM, Olof Johansson wrote:
> On Thu, Apr 10, 2014 at 06:37:14PM +0900, Chanwoo Choi wrote:
>> This patch add memory mapping for PMU (Power Management Unit) which is used
>> for power control of Exynos3250.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Signed-off-by is in the wrong order, if Kyungmin wrote the patch and you're
> just posting it...


No, I implemented this patch and posted it.

Best Regards,
Chanwoo Choi

