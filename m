Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965390AbaDJDum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:50:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50177 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965326AbaDJDui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:50:38 -0400
X-AuditID: cbfee68f-b7f156d00000276c-78-5346150cb540
Message-id: <5346150D.5050307@samsung.com>
Date: Thu, 10 Apr 2014 12:50:37 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] extcon: max14577: Fix probe failure on successful work
 queue
References: <1397037369-24995-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1397037369-24995-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWyRsSkWJdH1C3YYON+MYvXLwwtLu+aw2Zx
	u3EFm8WCjY8YHVg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2NdzxrGghnsFb0Pl7M0MH5h
	7WLk5JAQMJE4uP00E4QtJnHh3nq2LkYuDiGBpYwSM7+uYYIpalu7nhEiMZ1RYsuF6VDOa0aJ
	xas7wUbxCmhJrHjaBdbBIqAqsfv/O3YQmw0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRQQM
	JQ7u3g7WyyyQLHF5ayNYvbBAsMTKWa+YQWwhAXeJtlsvwGZyCnhIfFuwD6peR2J/6zQ2CFte
	YvOat8wgx0kIzGOXePL2BivEQQIS3yYfAlrGAZSQldh0gBniM0mJgytusExgFJuF5KRZSMbO
	QjJ2ASPzKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzA2Dn971n/Dsa7B6wPMSYDrZzILCWa
	nA+MvbySeENjMyMLUxNTYyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wDhbtcwhw65Hr+6a6NaG/bnub92zd5efOLj9VyL3ywpxU+NVgvLGahyuG5PW3Oi+8vpkerXM
	TMmG2aqmM0yunDOPWcfwgbXTYUleuHpclubj0Gtffa81cnuysMgt7f5te6mucoLeSVfn/1f/
	bYybJLpX2mJn/Uq3VfqbihSLj1jP+V7vpP74sBJLcUaioRZzUXEiAJXCJgGzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQV0eUbdgg7cT+C1evzC0uLxrDpvF
	7cYVbBYLNj5idGDx6NuyitHj8ya5AKaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
	Q0sLcyWFvMTcVFslF58AXbfMHKBFSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM
	0EDCGsaMdT1rGAtmsFf0PlzO0sD4hbWLkZNDQsBEom3tekYIW0ziwr31bF2MXBxCAtMZJbZc
	mM4I4bxmlFi8uhOsg1dAS2LF0y4mEJtFQFVi9/937CA2G1B8/4sbbCC2qECYxMrpV1gg6gUl
	fky+B2aLCBhKHNy9HayXWSBZ4vLWRrB6YYFgiZWzXjGD2EIC7hJtt16AzeQU8JD4tmAfVL2O
	xP7WaWwQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/d
	xAiOzGfSOxhXNVgcYhTgYFTi4T2wzDVYiDWxrLgy9xCjBAezkgivgpBbsBBvSmJlVWpRfnxR
	aU5q8SHGZGAITGSWEk3OByaNvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphak
	FsFsYeLglGpglPQRX7XsOmf4Lps2j0UdMbsMTUqsndi5M6dpnwqOzT5XOMvWL0m86p/qjDfd
	dg3lXzzEORkPynz6ebzh2uOuvktVDmdYMuZ89rUrnacWzr30Y83JPbfOOCT2F39TdFA9+adV
	f/blmoLV7pO2nvpQNX3rFsUVsfOjRFSv8FYX7zE7HPn7VME2JZbijERDLeai4kQAP64xxxAD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 04/09/2014 06:56 PM, Krzysztof Kozlowski wrote:
> In probe the driver queued delayed work for cable detection and
> returned the result of queue_delayed_work() call. However the return
> value of queue_delayed_work() does not indicate an error and in normal
> condition it returns true which means successful work queue.
> This effectively resulted in probe failure:
> [    2.088204] max14577-muic: probe of max77836-muic failed with error 1
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 962e56bfcf0b ("extcon: max14577: Add extcon-max14577 driver...")
> ---
>  drivers/extcon/extcon-max14577.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Applied this patch.
but, you could check this patch on extcon-next branch
after few days. becuase I have firewall issue of kerner.org.

Thanks,
Chanwoo Choi


