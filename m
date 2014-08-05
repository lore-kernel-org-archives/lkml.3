Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaHEGCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 02:02:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60128 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbaHEGCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 02:02:36 -0400
X-AuditID: cbfee690-b7f526d000003627-15-53e07371656d
Message-id: <53E0736E.7030901@samsung.com>
Date: Tue, 05 Aug 2014 15:02:22 +0900
From: YoungJun Cho <yj44.cho@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Wood <thomas.wood@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Inki Dae <daeinki@gmail.com>, Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: linux-next: build failures after merge of the drm tree
References: <20140805130926.4e8c8fe5@canb.auug.org.au>
In-reply-to: <20140805130926.4e8c8fe5@canb.auug.org.au>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zHd3C4gfBBhens1n0njvJZPF30jF2
	i6ddF5ktFj68y2zRu+Aqm8Wmx9dYLS7vmsNmcXBhG6PFqeuf2SymLDrMarH5w0s2i617r7Jb
	NJ14yObA69HS3MPm8fvXJEaPxhs32Dz2flvA4rFz1l12j8V7XjJ5bP/2gNVj85J6jysnmlg9
	+rasYvT4vEkugDuKyyYlNSezLLVI3y6BK2PzjiPsBVskKpqeX2ZtYJwt0sXIySEhYCJx8t0V
	dghbTOLCvfVsXYxcHEICyxglLn19zgJT1PTwGSNEYjqjxPnzW1ggnFeMEltXX2MCqeIV0JJY
	c28X2CgWAVWJ+1tmMoLYbAKaEs8/7mAFsUUFQiTeHG9nh6gXlPgx+R7YIBGBm4wSHVc/gznM
	Ak1MEieWTgDrFhZwlnj2rwXMFhIwk+jrnc4MYnMKmEs8vzSDDcRmFrCVWPB+HQuELS+xec1b
	Zoi7l3JI/N2uAnGRgMS3yYeAajiA4rISmw5AlUhKHFxxg2UCo9gsJDfNQjJ1FpKpCxiZVzGK
	phYkFxQnpReZ6BUn5haX5qXrJefnbmKERPyEHYz3DlgfYkwGWjmRWUo0OR+YMPJK4g2NzYws
	TE1MjY3MLc1IE1YS51V7lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTHnCNsShumJbbsP
	5Hyx/yH2e+bt65fNfp36enWDgJBt1/Hs+/8m6U9gWzDvziHnOTHr/z6/mbM33vejRL3p8ZWL
	7V+1rWcTFLgesanhgGArk/TuL0ty5byk10cu8q5+0BdXOaF789FTTBclz/JZ+IlNlf6UU7m5
	OP7Nmb/2+yYfbxK5d/lEjk2mEktxRqKhFnNRcSIAiCEzsg4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd3C4gfBBiuDLHrPnWSy+DvpGLvF
	066LzBYLH95ltuhdcJXNYtPja6wWl3fNYbM4uLCN0eLU9c9sFlMWHWa12PzhJZvF1r1X2S2a
	Tjxkc+D1aGnuYfP4/WsSo0fjjRtsHnu/LWDx2DnrLrvH4j0vmTy2f3vA6rF5Sb3HlRNNrB59
	W1YxenzeJBfAHdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkD9IGSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPzjiPsBVsk
	KpqeX2ZtYJwt0sXIySEhYCLR9PAZI4QtJnHh3nq2LkYuDiGB6YwS589vYYFwXjFKbF19jQmk
	ildAS2LNvV3sIDaLgKrE/S0zwbrZBDQlnn/cwQpiiwqESLw53s4OUS8o8WPyPbBBIgI3GSU6
	rn4Gc5gFmpgkTiydANYtLOAs8exfC5gtJGAm0dc7nRnE5hQwl3h+aQYbiM0sYCux4P06Fghb
	XmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKeTZ1I7
	GFc2WBxiFOBgVOLhFVC7HyzEmlhWXJl7iFGCg1lJhHd3zINgId6UxMqq1KL8+KLSnNTiQ4ym
	wDCYyCwlmpwPTHV5JfGGxiZmRpZGZsYm5sbGSuK8B1qtA4UE0hNLUrNTUwtSi2D6mDg4pRoY
	7ZsF9hXt+/p11zlB4cl1a1SYtt/n+7Omcs/U2Wu9cvduDkzfe6UpVMQ+u/NYxIW09JYHa0+b
	nMo95l7Ef/x+/nMdJvcKnvJd5ZFX3WcaVnF+tT4nzub7gZO7veGu0Cuvf2KZB2SCNRsLbz5n
	6m9+vVr+3r7eCKfPoZOtuLYpH7rHqPw3aYuaEktxRqKhFnNRcSIAZlv5Qj0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen and Dave,

On 08/05/2014 12:09 PM, Stephen Rothwell wrote:
> Hi Dave,
>
> After merging the drm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "drm_sysfs_connector_remove" [drivers/gpu/drm/i2c/tda998x.ko] undefined!
> ERROR: "drm_sysfs_connector_add" [drivers/gpu/drm/i2c/tda998x.ko] undefined!
>
> Caused by commit c707c3619ca8 ("drm/i2c: tda998x: add component
> support") interacting with commit 34ea3d386347 ("drm: add register and
> unregister functions for connectors").  Maybe it should have been fixed
> up in the merge commit 920f946428b7 ("Merge branch 'tda998x-devel' of
> git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next")?
>
> I reverted commit c707c3619ca8 for today.
>
> But then the arm multi_v7_defconfig build produced these errors:
>
> ERROR (phandle_references): Reference to non-existent node or label "disp_pd"
>
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[2]: *** [arch/arm/boot/dts/exynos5420-arndale-octa.dtb] Error 2
> make[2]: *** Waiting for unfinished jobs....
> ERROR (phandle_references): Reference to non-existent node or label "disp_pd"
>
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[2]: *** [arch/arm/boot/dts/exynos5420-smdk5420.dtb] Error 2
> ERROR (phandle_references): Reference to non-existent node or label "disp_pd"
>
> ERROR: Input tree has errors, aborting (use -f to force output)
> ERROR (phandle_references): Reference to non-existent node or label "disp_pd"
>
> make[2]: *** [arch/arm/boot/dts/exynos5800-peach-pi.dtb] Error 2
> ERROR: Input tree has errors, aborting (use -f to force output)
>
> Caused by commit 5a8da524049c ("ARM: dts: exynos5420: add dsi node")
> interacting with commit d51cad7df871 ("ARM: dts: remove display power
> domain for exynos5420") from the arm-soc tree.
>

I missed the patch "ARM: dts: remove display power domain for 
exynos5420" in linux-samsung-soc mail thread.

In my test without power domain property, the exynos5420 dsi master 
driver works well.

> I applied this merge fix patch:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 5 Aug 2014 13:03:01 +1000
> Subject: [PATCH] ARM: dts: exynos5420: remove disp_pd
>
> per comit d51cad7df871 ("ARM: dts: remove display power
> domain for exynos5420").
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>   arch/arm/boot/dts/exynos5420.dtsi | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 95ec37dff3e8..bfe056d9148c 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -525,7 +525,6 @@
>   		compatible = "samsung,exynos5410-mipi-dsi";
>   		reg = <0x14500000 0x10000>;
>   		interrupts = <0 82 0>;
> -		samsung,power-domain = <&disp_pd>;
>   		phys = <&mipi_phy 1>;
>   		phy-names = "dsim";
>   		clocks = <&clock CLK_DSIM1>, <&clock CLK_SCLK_MIPI1>;
>

Tested-by: YoungJun Cho <yj44.cho@samsung.com>

Thank you.
Best regards YJ


