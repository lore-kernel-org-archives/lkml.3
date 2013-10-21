Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3JUNuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:50:51 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33947 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3JUNut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:50:49 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-ee-5265313805af
Message-id: <52653132.4090803@samsung.com>
Date: Mon, 21 Oct 2013 15:50:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] spi/s3c64xx: Do not ignore return value of
 spi_master_resume/suspend
References: <1382362971-16763-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1382362971-16763-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7oWhqlBBt3POSymPnzCZvH6haFF
	74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7Jo/HiT3YHDY9OqTjaPzUvqPfq2rGL0+LxJLoAl
	issmJTUnsyy1SN8ugSvj24K7LAXfmCp6b31kamA8xNTFyMkhIWAi8fntO2YIW0ziwr31bF2M
	XBxCAksZJe6tfgpWJCTwiVHi9z0OEJtXQEti6qK7bCA2i4CqxPnJlxlBbDYBQ4neo31gtqhA
	mMTRpp+sEPWCEj8m32MBsUUEKiSezm5lBlnALLCZUWLCqVNgg4QF4iVOTVvFCrHMXWLSuxlg
	F3EKeEicfHEc7AhmAR2J/a3T2CBseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpamlxQnJSe
	a6RXnJhbXJqXrpecn7uJERLiX3cwLj1mdYhRgINRiYc3wCUlSIg1say4MvcQowQHs5II7+eP
	QCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mns5Bm988C995YXPfldaC901s27WWszIom+s9qYz5
	0fvfevnVPf+m7lkQI7g+I67nSsVnLa/G9SEG25zPZSZe0J/AzVi5TXLjpu8qrK7n13HkLLh8
	d67Oo/e53yezhK2W4St7tiGzxLDtFY83c2ruz/bg3zGSL//4vf3bmTrlVXue13G2vjnrlViK
	MxINtZiLihMB5zLre08CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/13 15:42, Krzysztof Kozlowski wrote:
> During PM resume and suspend do not ignore the return value of
> spi_master_suspend() or spi_master_resume(). Instead pass it further.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
