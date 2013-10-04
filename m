Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3JDCVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:21:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54320 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3JDCVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:21:21 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-75-524e25f02a09
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sean Paul'" <seanpaul@chromium.org>
Cc: kgene.kim@samsung.com, dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com, airlied@linux.ie,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
 <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
 <1380839303-4834-2-git-send-email-seanpaul@chromium.org>
In-reply-to: <1380839303-4834-2-git-send-email-seanpaul@chromium.org>
Subject: Re: [PATCH v2 1/5] ARM: dts: Add fimd display-timings for
 exynos5250-snow
Date: Fri, 04 Oct 2013 11:20:32 +0900
Message-id: <000401cec0a8$4d53a850$e7faf8f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7AiCzMsYQm0vZHQiWKksQMasKPmwAH4y5Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zY90Pqn5BBvOOalv0njvJZDH/yDlW
	iytf37NZTLo/gcXi8sJLrBa9C66yWWx6fI3VYmHbEqDYrjlsFjPO72OyuLvhLKMDt8fshoss
	Htu/PWD1uN99nMlj85J6j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MrY1zmXqeAke8WpJZMZ
	Gxg72boYOTkkBEwknqz8yAhhi0lcuLceKM7FISSwjFFi0rO/7DBFj4/MZoZILGKUaHlzmwXC
	+cUo8W3jJlaQKjYBNYkvXw6DdYgIqEtc+7sdrIhZYA2TxLK5S5ggOnYzSryeOIUZpIpTwFVi
	7ecFYLawQIhE49GPYJNYBFQljsy9wARi8wrYSly+OZ0dwhaU+DH5HguIzSygJbF+53EmCFte
	YvOat0BzOIBuVZd49FcX4ggjia+XJrBDlIhI7HvxDurPiRwSy3pdIVYJSHybfIgFolVWYtMB
	ZogSSYmDK26wTGCUmIVk8Swki2chWTwLyYYFjCyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3
	MUIifsIOxnsHrA8xJgOtn8gsJZqcD0wYeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeW
	pGanphakFsUXleakFh9iZOLglGpgDLr6es+KwuXbz0hct08KF5mq3ytxtOzdTI5lF5ytfnx7
	N+WEKIOunT/zxxtL55fsadvw89/XVXd2aEs8rTFaxBR16f80g+kZ9meCc526XjLnyjo/YnuQ
	fG6Zx6L6WXMTZyeEKOXuL1prv9uu5mVKefzLpgremROC9GXPVb5WDGH/a6P388uxUCWW4oxE
	Qy3mouJEAEOmiBkOAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAd0Pqn5BBttPqVn0njvJZDH/yDlW
	iytf37NZTLo/gcXi8sJLrBa9C66yWWx6fI3VYmHbEqDYrjlsFjPO72OyuLvhLKMDt8fshoss
	Htu/PWD1uN99nMlj85J6j74tqxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1
	MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6T0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQ
	XI+RARpIWMeYsa9zLlPBSfaKU0smMzYwdrJ1MXJySAiYSDw+MpsZwhaTuHBvPVCci0NIYBGj
	RMub2ywQzi9GiW8bN7GCVLEJqEl8+XKYHcQWEVCXuPZ3O1gRs8AaJollc5cwQXTsZpR4PXEK
	2FxOAVeJtZ8XgNnCAiESjUc/gk1iEVCVODL3AhOIzStgK3H55nR2CFtQ4sfkeywgNrOAlsT6
	nceZIGx5ic1r3gLN4QC6VV3i0V9diCOMJL5emsAOUSIise/FO8YJjEKzkEyahWTSLCSTZiFp
	WcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKE8k9rBuLLB4hCjAAejEg+vQK1vkBBr
	YllxZe4hRgkOZiUR3tOfgEK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0x2eSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAOPXQpNDlTx2M9j6afcdO0/KP
	7uT1P18+KGd41ils8E9j5sdd+bEHDr5LtWBN+Huyq2RP573P045GdLb+vu/Xb1+XPTVmvX/s
	r8US69V9hFbf+JeTxJM/n22vXeR+0atT1bQzl7bce3XZquqJ+P8HG/6HHgs8+nDBod3npkbO
	23wkeNcS949FU1YpsRRnJBpqMRcVJwIAaqE/mWwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 04, 2013 7:28 AM, Sean Paul wrote:
> 
> This patch adds the internal panel timings to the exynos5250-snow board
> dts file.
> 
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---
> 
> v2: No difference
> 
>  arch/arm/boot/dts/exynos5250-snow.dts | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index fd711e2..2a0f0de 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -186,6 +186,23 @@
>  		samsung,vbus-gpio = <&gpx1 1 0>;
>  	};
> 
> +	fimd: fimd@14400000 {
> +		display-timings {

How about adding 'status = "okay"' as below? 

	fimd: fimd@14400000 {
		status = "okay";
		display-timings {

status of fimd node was disabled by exynos5.dtsi 

./arch/arm/boot/dts/exynos5.dtsi
fimd@14400000 {
		status = "disabled";

Best regards,
Jingoo Han

