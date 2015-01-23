Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbbAWAt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:49:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19949 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbAWAtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:49:20 -0500
X-AuditID: cbfee68e-f79b46d000002b74-ba-54c19a8da3a9
Date: Fri, 23 Jan 2015 09:49:16 +0900
From: Inha Song <ideal.song@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: alsa-devel@alsa-project.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, lgirdwood@gmail.com,
        tiwai@suse.de, broonie@kernel.org, kgene@kernel.org,
        galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v3 3/4] ARM: dts: set clock out parent to
 XUSBXTI
Message-id: <20150123094916.32beb50f@songinha-Samsung-DeskTop-System>
In-reply-to: <54C0EC23.9070209@samsung.com>
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
 <1421925482-15861-4-git-send-email-ideal.song@samsung.com>
 <54C0EC23.9070209@samsung.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsWyRsSkRLd31sEQgxlzFC2uXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotzr1YyWvQ/fs1s8e1KB5PFpsfXWC0u75rDZjHj/D4mi9uXeS2W
	Xr/IZDFh+loWi9a9R9gtDr9pZ7W4uOILk8XLzW+YHIQ8NnxuYvNYM28No0dLcw+bx+W+XiaP
	nbPusnusXP6FzWPTqk42jzvX9rB5bF5S79G3ZRWjx+bT1R6fN8kF8ERx2aSk5mSWpRbp2yVw
	ZTx5v4yxYBFPxe2uVpYGxt+cXYycHBICJhLrdtxlgbDFJC7cW8/WxcjFISSwlFHif8dvIIcD
	rOjsnFKI+HRGieuTNrOBNAgJ9DNJLP5bCmKzCKhK3J7ezAxiswloSHz/vBnMFhHQl1iy6iLY
	UGaBjcwSU34cYQIZKiwQIvFyoh5IDa+Aq8TMJzuYQGxOAW2Jp9v3sUMsWwK0rHsBM8R1NhKr
	d65jhmgQlPgx+R7Y1cwCWhKbtzWxQtjyEpvXvGUGaZYQuMAhcXDmK1aI6wQkvk0+xALxjazE
	pgNQMyUlDq64wTKBUWwWkrGzkIydhWTsAkbmVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiB
	SeL0v2d9OxhvHrA+xCjAwajEw5tRfCBEiDWxrLgy9xCjKdAVE5mlRJPzgakoryTe0NjMyMLU
	xNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxsn2WmfPGv3lnuiy9lP8
	0rnJC+5yu8s5TzbxPir9K+Tvucdcu6/7z9h8Jb6s9nR8XkNZ7AK/0Nuf+z4V6RbEyikfP+Qq
	ldQ9N7V//9GKuklfuEyZK1eey0hx8zp5Yy2r38Hm6Yfv6Llc2V640mD5h6j9TTannkQ+2jLj
	b5lgsIwlV/fKjVc8spRYijMSDbWYi4oTATxTOwsNAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQd3eWQdDDL7fE7e4cvEQk8XUh0/Y
	LOYfOcdq0f9mIavFgT87GC3OvVrJaNH/+DWzxbcrHUwWmx5fY7W4vGsOm8WM8/uYLG5f5rVY
	ev0ik8WE6WtZLFr3HmG3OPymndXi4oovTBYvN79hchDy2PC5ic1jzbw1jB4tzT1sHpf7epk8
	ds66y+6xcvkXNo9NqzrZPO5c28PmsXlJvUffllWMHptPV3t83iQXwBPVwGiTkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SekkJZYk4pUCggsbhYSd8O
	04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjyftljAWLeCpud7WyNDD+5uxi5OCQEDCRODuntIuR
	E8gUk7hwbz1bFyMXh5DAdEaJ65M2s4EkhAT6mSQW/wUrYhFQlbg9vZkZxGYT0JD4/nkzmC0i
	oC+xZNVFsGZmgY3MElN+HGECWSAsECLxcqIeSA2vgKvEzCc7mEBsTgFtiafb97FDLFsCtKx7
	ATPEFTYSq3euY4ZoEJT4MfkeC4jNLKAlsXlbEyuELS+xec1b5gmMArOQlM1CUjYLSdkCRuZV
	jKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEp6JnUDsaVDRaHGAU4GJV4eDOKD4QIsSaWFVfm
	HmKU4GBWEuHdXHAwRIg3JbGyKrUoP76oNCe1+BCjKTA4JjJLiSbnA9NjXkm8obGJmZGlkbmh
	hZGxuZI4r5J9W4iQQHpiSWp2ampBahFMHxMHp1QD4wE2HYfdrhllK7V2NnnyNlb2fH26piWg
	KNXZ6Zd13BnR8/FWVXWGH3WMHxhsn3r0YSfzPt77ry+IfUrKn1zlzPndhX1mRXnSvKz7xRy7
	50YxLzWKrDzFvlR0/5yNG6fL7kuPulBYfY/j8brM6TW3TytYHcp/mFQksf9Fo32fbUe615s9
	qQenKbEUZyQaajEXFScCACck9KxXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for your comment.

On Thu, 22 Jan 2015 13:25:07 +0100
Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:

> On 22/01/15 12:18, Inha Song wrote:
> > This patch set clock out parent to XUSBXTI.
> > 
> > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > ---
> >  arch/arm/boot/dts/exynos4.dtsi | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> > index b8168f1..020bbaf 100644
> > --- a/arch/arm/boot/dts/exynos4.dtsi
> > +++ b/arch/arm/boot/dts/exynos4.dtsi
> > @@ -141,6 +141,8 @@
> >  	pmu_system_controller: system-controller@10020000 {
> >  		compatible = "samsung,exynos4210-pmu", "syscon";
> >  		reg = <0x10020000 0x4000>;
> > +		assigned-clocks = <&pmu_system_controller 0>;
> > +		assigned-clock-parents =  <&clock CLK_XUSBXTI>;
> >  	};
> 
> Looks good, except it needs to be done only for the Trats2 board, i.e.
> the PMU device node including these properties should be added to
> exynos4412-trats2.dts.  I think it's fine to make it a one patch including
> all dts changes.

Opps! I understand. I will move this node to exynos4412-trats2.dts.

&pmu_system_controller {
   assigned-clocks = <&pmu_system_controller 0>;
   assigned-clock-parents =  <&clock CLK_XUSBXTI>;
};

Thanks!

Best Regards,
Inha Song.

> 
> 
> -- 
> Regards,
> Sylwester
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
