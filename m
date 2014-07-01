Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaGAB4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:56:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40925 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGAB4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:56:01 -0400
X-AuditID: cbfee690-b7fb56d000003439-10-53b2152feb24
From: Jingoo Han <jg1.han@samsung.com>
To: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Cc: "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1403784006-17605-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1403784006-17605-1-git-send-email-k.kozlowski@samsung.com>
Subject: Re: [PATCH RESEND] clk: samsung: Make of_device_id array const
Date: Tue, 01 Jul 2014 10:55:58 +0900
Message-id: <00a201cf94cf$9a8ee1b0$cfaca510$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+RNjWRbihdFqZUSxeo+xDtmcId6wDmT0ew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zfV190U3BBp9uc1hcXniJ1eL1C0OL
	3gVX2Sw2Pb7GanF51xw2ixnn9zFZPJ1wkc1i/YzXLA4cHneu7WHz2Lyk3qNvyypGj8+b5AJY
	orhsUlJzMstSi/TtErgytt45xFZwkLXiwsuvTA2MG1i6GDk5JARMJDbd/8oKYYtJXLi3nq2L
	kYtDSGAZo8SKZV/ZYIrWtU6CSixilLi24iQThPObUWLVtLnsIFVsAmoSX74cBrNFBIwl1sxc
	CtbBLNDJJPF+5UWwHUIC7hIrmycwgticAh4SUya/AGsQBopvvHWACcRmEVCVeLNzCjOIzStg
	K3GnYz07hC0o8WPyPbC7mQW0JNbvPM4EYctLbF7zFqieA+hUdYlHf3UhbjCSuNlzmBmiRERi
	34t3jCD3SAi8ZJf48WoGC8QuAYlvkw+xQPTKSmw6wAzxsaTEwRU3WCYwSsxCsnkWks2zkGye
	hWTFAkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxgh0TthB+O9A9aHGJOB1k9klhJNzgdG
	f15JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MFpK
	nBTKW7v/yOvQ35leigrhu7vbZsww3nqwvrE7dn3TrB8Hnko627z+JyDR+PTh26taD969+dJ0
	lpsj/6ZG8LkTlSxhE/QF9/SVfGvwrJis03Gl78hC2fSglY929x+bv2b30p2H7odsffuRY0Ks
	rfqp0N7fDYIWxtv0r/7zsTnr0a6bPnVDmJASS3FGoqEWc1FxIgDZDoM79AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAV190U3BBu23WSwuL7zEavH6haFF
	74KrbBabHl9jtbi8aw6bxYzz+5gsnk64yGaxfsZrFgcOjzvX9rB5bF5S79G3ZRWjx+dNcgEs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM7beOcRWcJC14sLLr0wNjBtY
	uhg5OSQETCTWtU5ig7DFJC7cWw9kc3EICSxilLi24iQThPObUWLVtLnsIFVsAmoSX74cBrNF
	BIwl1sxcCtbBLNDJJPF+5UVWkISQgLvEyuYJjCA2p4CHxJTJL8AahIHiG28dYAKxWQRUJd7s
	nMIMYvMK2Erc6VjPDmELSvyYfA/sPGYBLYn1O48zQdjyEpvXvAWq5wA6VV3i0V9diBuMJG72
	HGaGKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yf
	u4kRnBqeSe1gXNlgcYhRgINRiYdXoWFjsBBrYllxZe4hRgkOZiUR3r8cm4KFeFMSK6tSi/Lj
	i0pzUosPMZoCPTqRWUo0OR+YtvJK4g2NTcyMLI3MLIxMzM2VxHkPtFoHCgmkJ5akZqemFqQW
	wfQxcXBKNTCuOCD/76hN34Lr/GdXnj092/fNxO2vj8xY2c217//aWZ1Hw/e52FstnLCqufjs
	qjduN6TmCs4UtdrmX7gqxD7H6ftnBqPwgB+6omorGuTFFTY8j2xb7lTweGbrzqTJgct+Prh1
	6vRKzR/e2vqxi8q+Nmxc8H/C/MIVrj4svleumqhO33ZXq+bxHSWW4oxEQy3mouJEALmLNP8j	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 26, 2014 9:00 PM, Krzysztof Kozlowski wrote:
> 
> Array of struct of_device_id may be be const as expected by
> of_match_table field and of_find_matching_node_and_match() function.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/clk/samsung/clk-exynos4.c    | 2 +-
>  drivers/clk/samsung/clk-exynos5250.c | 2 +-
>  drivers/clk/samsung/clk-exynos5420.c | 2 +-
>  drivers/clk/samsung/clk-exynos5440.c | 2 +-
>  drivers/clk/samsung/clk.c            | 2 +-
>  drivers/clk/samsung/clk.h            | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 

