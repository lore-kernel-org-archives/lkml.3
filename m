Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3A3FMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 00:12:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15034 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3A3FMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 00:12:19 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-1f-5108abb11b6a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, grant.likely@secretlab.ca,
        dianders@chromium.org, balbi@ti.com, thomas.abraham@linaro.org,
        sylvester.nawrocki@gmail.com, tomasz.figa@gmail.com,
        p.paneri@samsung.com
References: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
 <1358868680-5757-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1358868680-5757-3-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v2 2/2] ARM: Exynos5250: Enabling samsung-usb3-phy driver
Date: Tue, 29 Jan 2013 21:12:10 -0800
Message-id: <077901cdfea8$5db3aeb0$191b0c10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG7I7HiR5F9lZg6OQOiNsj3cWXGQgKmStZYmHHV0jA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zfd2NqzkCDRZtMLO4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGKyyYlNSezLLVI3y6BK+Pq19csBSs5Kjb/msjewLiNrYuRk0NCwERi
	8vs+ZghbTOLCvfVAcS4OIYFljBJ7DvcwwhRta7kElZjOKHHszi1GCOcvo8TZO+vYQarYBDQk
	Dr9/BmaLCARIfL31AqybWaCHSeLk5CCIhlZGie7Ld5m6GDk4OAU8JPbvBFstLOAr8ezIQyYQ
	m0VAVWLFzVmsICW8ApYS65+ClfAKCEr8mHyPBWKklsT6nceZIGx5ic1r3kJ9oCCx4+xrRogT
	rCR2NiyHqheXmPTgITvICRICm9gl9l2CuJNFQEDi2+RDLCC7JARkJTYdgJojKXFwxQ2WCYwS
	s5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRki8Se1gXNlgcYhR
	gINRiYd3wQv2QCHWxLLiytxDjBIczEoivApqHIFCvCmJlVWpRfnxRaU5qcWHGJOBjp3ILCWa
	nA9MBXkl8YbGxiZmJqYm5pam5qakCSuJ8zKeehIgJJCeWJKanZpakFoEs4WJg1OqgTFux+Fb
	/AneR25tX9Zw9ZpVV9xKVdHriyaJsBcnXlm69rDs+/N7VkdKWyQ2PL0dqerw+oLYJ7uk+9xm
	yjMX/eLwUnJRYbIwSP1g+8VgvVFTbo1fzI+17TuWqB3ZOdu3LGvXib6kgrPK3hMad9qp8p4X
	sl78z9DQ5kX7y6q/7Z7lfalRTJLcV5VYijMSDbWYi4oTAdrXOlz7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd2NqzkCDTbcMLK4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj6tfX
	LAUrOSo2/5rI3sC4ja2LkZNDQsBEYlvLJShbTOLCvfVANheHkMB0Roljd24xQjh/GSXO3lnH
	DlLFJqAhcfj9MzBbRCBA4uutF4wgNrNAD5PEyclBEA2tjBLdl+8ydTFycHAKeEjs38kMUiMs
	4Cvx7MhDJhCbRUBVYsXNWawgJbwClhLrn4KV8AoISvyYfI8FYqSWxPqdx5kgbHmJzWveMkMc
	qiCx4+xrRogTrCR2NiyHqheXmPTgIfsERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kRHM3PpHYwrmywOMQowMGoxMO74AV7oBBrYllxZe4hRgkOZiURXgU1
	jkAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcmmrySeENjEzMjSyMzCyMTc3PShJXEeRlP
	PQkQEkhPLEnNTk0tSC2C2cLEwSnVwBiTpWSp/vDunjsCvlcVvm6clHjqmenNo8oyApwy949H
	rY/PCfkhtITdW6VVre7LlNu7772+t2V6wTrDOQo33rA1p3Af2Bq8M+WKaI9H5NK9gar35pjs
	tnfb6RCw5W3j4TvczWntf61m9YawX3DQy5tWd7JpWuRqDt3Vk6skOa7s83S4embpn+NKLMUZ
	iYZazEXFiQBqCw2EKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Adding usb3.0 phy node for Exynos5250 along with the
> necessary device data to be parsed.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi
> index 610e338..018a70d 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -275,6 +275,19 @@
>  		#size-cells = <0>;
>  	};
> 
> +	usbphy@12100000 {
> +		compatible = "samsung,exynos5250-usb3-phy";
> +		reg = <0x12100000 0x100>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		usbphy-sys {
> +			      /* USB device and host PHY_CONTROL registers
*/
> +			reg = <0x10040704 0x8>;
> +		};
> +	};
> +
>  	usbphy@12130000 {
>  		compatible = "samsung,exynos5250-usbphy";
>  		reg = <0x12130000 0x100>;
> --
> 1.7.6.5

Same as previous comments.

Thanks.

- Kukjin



