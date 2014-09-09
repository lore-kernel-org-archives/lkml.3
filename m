Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbaIIMY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:24:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30679 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaIIMY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:24:27 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-a1-540ef1784993
Message-id: <540EF177.8090005@samsung.com>
Date: Tue, 09 Sep 2014 14:24:23 +0200
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, s.nawrocki@samsung.com,
        mturquette@linaro.org, naushad@samsung.com
Subject: Re: [PATCH] clk: samsung: exynos3250: fix mout_cam_blk parent list
References: <1410008613-20861-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1410008613-20861-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xq7oVH/lCDI59M7d4/cLQonfBVTaL
	TY+vsVpc3jWHzWLG+X1MFk8nXGSz+HT0P6vFoq1f2C0Ov2lntVi16w+jA5fHzll32T3uXNvD
	5rF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZXTtX8BYMIOj4tT7BYwNjAfZuhg5OSQE
	TCS27LvEDGGLSVy4tx4ozsUhJLCUUWLV7TtQzmdGicVNZ1lAqngFtCSa+t8wgdgsAqoS7ye0
	MYLYbAIeEtO+94BNEhUIk3j26yATRL2gxI/J91hABokITGOUuHjpNjtIglmgTGLhjWlgRcIC
	3hKTlhwGaxYCGrT11V+gzRwcnAKeEp9mhkOUm0l8eXmYFcKWl9i85i3zBEaBWUhWzEJSNgtJ
	2QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIRHwdQfj0mNWhxgFOBiVeHgnlvGFCLEm
	lhVX5h5ilOBgVhLhtX4BFOJNSaysSi3Kjy8qzUktPsTIxMEp1cDo/aC2VjF6hsmkUzr+Yk56
	E4PXv5ikrR6zY9MZKfMmxcVeZmyHOl+qr9Dcumbt2YAP72c9/aCwl8NQjdPPVD2xg/dRov2v
	r7YLr+0/EFL0Q90k/sFhh5f33G5e+il8J1UwZY1zOPtv9p3vrO8WRC/ymRoosXvmt4Jt8hrO
	lxbWLnthtMfRcN8vJZbijERDLeai4kQASLn8GV4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.09.2014 15:03, Pankaj Dubey wrote:
> As per user manual of Exynos3250 SRC_CAM can select
> div_cam_blk_320 if it's value is 0xC, so placing
> div_cam_blk_320 at proper index in parent list of mout_cam_blk.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos3250.c |    1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

>
> diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
> index e1cb464..ba8f073f 100644
> --- a/drivers/clk/samsung/clk-exynos3250.c
> +++ b/drivers/clk/samsung/clk-exynos3250.c
> @@ -248,6 +248,7 @@ PNAME(group_sclk_cam_blk_p)	= { "xxti", "xusbxti",
>   				    "none", "none", "none",
>   				    "none", "div_mpll_pre",
>   				    "mout_epll_user", "mout_vpll",
> +				    "none", "none", "none",
>   				    "div_cam_blk_320", };
>   PNAME(group_sclk_fimd0_p)	= { "xxti", "xusbxti",
>   				    "m_bitclkhsdiv4_2l", "none",
>

