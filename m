Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaKGLvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:51:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31972 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaKGLu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:50:59 -0500
X-AuditID: cbfee68d-f79296d000004278-19-545cb221d317
Message-id: <545CB220.9030007@samsung.com>
Date: Fri, 07 Nov 2014 20:50:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Fix booting on Rinato market device
References: <1415360662-30390-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1415360662-30390-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkUFdxU0yIwY/fnBaT1h1gsph/5Byr
	Rf+bhawW516tZLR4/cLQonfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81osvX6RyWLC9LUsFq17
	j7A78HqsmbeG0aOluYfN43JfL5PH31UvmD1WLv/C5rFpVSebx+Yl9R59W1YxenzeJBfAGcVl
	k5Kak1mWWqRvl8CVcWHSP5aCtXwVz658ZG9g/M7dxcjBISFgInF1r30XIyeQKSZx4d56ti5G
	Lg4hgaWMEmvP3WWFSJhITLy4gBUisYhR4v6SiVBVrxkl/jxYxAhSxSugJXHu6X0WEJtFQFVi
	3/ujYDYbUHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosIGEoc3L2dCWQos8A2ZonXR6aCDRUW
	cJJYuOsVWLOQgLvEwo+3wOKcAh4S1zYfAmtmFtCR2N86jQ3ClpfYvOYtM8ggCYFeDol5q06w
	QVwkIPFtMkgDyM+yEpsOMEO8JilxcMUNlgmMYrOQ3DQLydhZSMYuYGRexSiaWpBcUJyUXmSo
	V5yYW1yal66XnJ+7iREY16f/PevdwXj7gPUhRgEORiUe3hu8MSFCrIllxZW5hxhNga6YyCwl
	mpwPTB55JfGGxmZGFqYmpsZG5pZmSuK8ilI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	KoqosKzewVrpVRSzTbbFpXmegdLWDubH049cSYprZ7V3TPpgmsNuWvJgedXBK531kU2NTT5t
	CSz78psPhnrbnJofpLCE62S2RcTdiLXMrF6blx52kD4/7WTHmZO6nRvXzHuo+rXzYZDy5AcT
	nxx5v4dVh2FVJK/FVKczxlXCJpmzH6+WUvyrxFKckWioxVxUnAgAWAUFOeYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAV3FTTEhBseKLCatO8BkMf/IOVaL
	/jcLWS3OvVrJaPH6haFF74KrbBabHl9jtbi8aw6bxYzz+5gsbl/mtVh6/SKTxYTpa1ksWvce
	YXfg9Vgzbw2jR0tzD5vH5b5eJo+/q14we6xc/oXNY9OqTjaPzUvqPfq2rGL0+LxJLoAzqoHR
	JiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoaiWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxoVJ/1gK1vJVPLvykb2B8Tt3FyMn
	h4SAicTEiwtYIWwxiQv31rN1MXJxCAksYpS4v2QilPOaUeLPg0WMIFW8AloS557eZwGxWQRU
	Jfa9PwpmswHF97+4wQZiiwqESaycfoUFol5Q4sfke2C2iIChxMHd25lAhjILbGOWeH1kKthQ
	YQEniYW7XoE1Cwm4Syz8eAsszingIXFt8yGwZmYBHYn9rdPYIGx5ic1r3jJPYBSYhWTHLCRl
	s5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnDSeSe9gXNVgcYhRgINRiYf3Bm9M
	iBBrYllxZe4hRgkOZiUR3oANQCHelMTKqtSi/Pii0pzU4kOMpsAgmMgsJZqcD0xoeSXxhsYm
	ZkaWRuaGFkbG5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGCe1CNuyrXOaUHJR4VrXFV3x
	e3rpHUf7te+sbjIUO/XMpD1d9VNr15/JhY0+D7tPsgmUbORUjU3d0JzjWxrxS9L6doR+YakA
	47r0WPX6tOl8GtNVN0/yaM/9xjT/zzfWyG/LlWLFz8/q3f1Po/LPXLki49DG+RuKOJS8jgnv
	lJ27ZTr/3E8PlViKMxINtZiLihMB5dfyyDADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 11/07/2014 08:44 PM, Krzysztof Kozlowski wrote:
> The bootloader on market Rinato (Gear 2) device checks for revision in
> compatible field of DTB. If it is not present or lower than required
> then booting fails with: "Could not do normal boot. (no DTB found)".
> 
> Log of bootloader in case of failure:
> h/w: revision  = 0x06
> h/w: schematic = SM-R380_Rev0.5_Final_0205
> date = 2000/01/01 12:00:21 (UTC)
> cmu_div:4, div:5, src_clk:800000000, pixel_clk:31860720
> load_kernel: loading boot image from 57344.. (BOOT)
> load_kernel: found zImage, size: 0x3267e8
> 0xbc Error!
> Verify_Binary_Signature: failed.
> pit_check_signature (BOOT) invalid.
> load_kernel: found custom kernel (ret:-2147483647)
>  No need to update kernel type.
> Detected board: samsung,rinato-rev06
> Could not do normal boot. (no DTB found)
> : Entering usb mode for SM-R380_EUR_XX (65535)..
> 
> Add a "rev06" suffix to compatible to satisfy the bootloader.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250-rinato.dts | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
> index 84380fa13e37..f72ba0a1d915 100644
> --- a/arch/arm/boot/dts/exynos3250-rinato.dts
> +++ b/arch/arm/boot/dts/exynos3250-rinato.dts
> @@ -18,7 +18,8 @@
>  
>  / {
>  	model = "Samsung Rinato board";
> -	compatible = "samsung,rinato", "samsung,exynos3250", "samsung,exynos3";
> +	compatible = "samsung,rinato", "samsung,rinato-rev06",
> +			"samsung,exynos3250", "samsung,exynos3";

I think it is wrong. The released bootloader from Samsung is not u-boot.
Instead, you have to update u-boot to support Exynos3250-basd Rinato board.

Thanks,
Chanwoo Choi
