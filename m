Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab3CGLJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:09:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41529 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3CGLJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:09:33 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-d6-5138756b271b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        patches@linaro.org
References: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
 <1362568712-13586-2-git-send-email-thomas.abraham@linaro.org>
 <CACRpkdZ37FutKzwSSF7w425Nh=jPUU-FXf48HPs3oUXO9sJ0oA@mail.gmail.com>
In-reply-to: <CACRpkdZ37FutKzwSSF7w425Nh=jPUU-FXf48HPs3oUXO9sJ0oA@mail.gmail.com>
Subject: RE: [PATCH v2 1/3] pinctrl: exynos: add exynos5250 SoC specific data
Date: Thu, 07 Mar 2013 20:09:31 +0900
Message-id: <021201ce1b24$3e46e810$bad4b830$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4bCvaHSdWhq+o7SwCKG1e1FBVf8AAEeX9w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zY92cUotAg+/XGC0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ+PX/BXnCApWLlP7EGxtPMXYycHBICJhLLnn9hhLDF
	JC7cW88GYgsJLGOUeDVfEaZm6Yb3TBDxRYwSB/qtuhi5gOy/jBLTV+9lBUmwCWhIHH7/jB3E
	FhGIkzi8YRUTSBGzwGRGic4tq9ggOi4wSqw/dBasg1MgWOL8/29gq4UFfCUWdm4DO4lFQFXi
	1YZnYDW8ArYSt2Z1QtmCEj8m32MBsZkFtCTW7zzOBGHLS2xe8xaolwPoVHWJR391IY4wkjiw
	opMNokREYt+Ld1BfrmKX+NiqCLFKQOLb5EMsEK2yEpsOQANFUuLgihssExglZiFZPAvJ4llI
	Fs9CsmEBI8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJAI69/BePeA9SHGZKD1E5mlRJPz
	gRGaVxJvaGxsYmZiamJuaWpuSpqwkjiv/CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	xl8Tk/hiZ93dVn9hx+EfmnekcjZtsOhhDBISeLlm8ms5Keb2r76H/YWcPrLc2hxsfmTfmXc/
	OWeFSF5fevEKW8LkX/03GyPCik1fyO11U0vM6V+YUz97wkdtvq/7939LnWHqnqheqHnz2IfN
	bXnpCacsHkz/ftrloVy076TKfZP7w8XnxaZNUWIpzkg01GIuKk4EAPaiChrGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd3sUotAg/83LS0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzfj1/wV5wgKVi
	5T+xBsbTzF2MnBwSAiYSSze8Z4KwxSQu3FvPBmILCSxilDjQb9XFyAVk/2WUmL56LytIgk1A
	Q+Lw+2fsILaIQJzE4Q2rmECKmAUmM0p0blnFBtFxgVFi/aGzYB2cAsES5/9/YwSxhQV8JRZ2
	bgNbzSKgKvFqwzOwGl4BW4lbszqhbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95C9TLAXSqusSj
	v7oQRxhJHFjRyQZRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgx
	t7g0L10vOT93EyM4hp9J7WBc2WBxiFGAg1GJh5cj3zxQiDWxrLgy9xCjBAezkgjvBTmLQCHe
	lMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OB6aXvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRAS
	SE8sSc1OTS1ILYLZwsTBKdXAGJp2P+PKTce6rmMnJE6XndHPP8Xt9PIsX9pHq4octUgbydf7
	XlS+MuDKfazkPO3OG+eJcYwfDGdEHk6fv++gRpHLy3PrTot7fmVONAmfbZVYzJX+55PC7bNx
	/f5zmaz38k7uuXDaka1t/dbdZXtO6k2Z5cK7xmySw5KD+tvdSkzZ25UPfwlcpMRSnJFoqMVc
	VJwIAKXP5RQlAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Wed, Mar 6, 2013 at 12:18 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
> 
> > Add Samsung Exynos5250 SoC specific data to enable pinctrl support for
> > all platforms based on Exynos5250.
> >
> > Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> So shall I merge these three patches to the pinctrl tree or not?
> 
Hi Linus, this series is already in Samsung tree with your ack.

Thanks.

- Kukjin

