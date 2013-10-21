Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3JUNr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:47:29 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23572 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3JUNr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:47:27 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-f3-5265306d4c12
Message-id: <5265305D.9040203@samsung.com>
Date: Mon, 21 Oct 2013 15:47:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] spi/s3c64xx: Fix doubled clock disable on suspend
References: <1382362971-16763-1-git-send-email-k.kozlowski@samsung.com>
 <1382362971-16763-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1382362971-16763-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xq7q5BqlBBkuPaltMffiEzeL1C0OL
	3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2TR+PEmuwOHx6ZVnWwem5fUe/RtWcXo8XmTXABL
	FJdNSmpOZllqkb5dAlfGy9m7WQuWslRM7rvB1MB4lrmLkZNDQsBEYvbGK2wQtpjEhXvrgWwu
	DiGBpYwSZ7YfZwFJCAl8YpRY99oExOYV0JLYd3wHWDOLgKrE28WrmUBsNgFDid6jfYwgtqhA
	mMTRpp+sEPWCEj8m3wObIyJQIfF0diszyAJmgc2MEhNOnQLbLCzgJTH77XlGiM2tjBIvbraC
	JTgFPCT+Ht0BNpVZQEdif+s0NghbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqaWJhcUJ6Xn
	GuoVJ+YWl+al6yXn525ihAT5lx2Mi49ZHWIU4GBU4uENcEkJEmJNLCuuzD3EKMHBrCTC+/kj
	UIg3JbGyKrUoP76oNCe1+BAjEwenVAPjTK1ravOYPBTv3zPOWb39+NJe24cyLWe+N6y3sZCN
	E9lzQnvacdUtX/zWsESG8L3t/PvvzYUXPY+P93/maq4ybbf2sd5jutDoRf860etlE05EPX6y
	pDUq8OAq5w0HtKbPK+SZ+WhJ77k56uevaKhd/NhlzafpvH+OyKG3ATpPDrJqbdst+sDrmBJL
	cUaioRZzUXEiADjJNgVQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/13 15:42, Krzysztof Kozlowski wrote:
> Fix doubled clock disable and unprepare during PM suspend which triggered
> the warnings:

> The clocks may be already disabled before suspending. Check PM runtime
> suspend status and disable clocks only if device is not suspended.
> During resume do not enable the clocks if device is runtime suspended.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
