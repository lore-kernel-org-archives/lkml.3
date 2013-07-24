Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3GXPYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:24:16 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64800 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3GXPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:24:15 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-23-51eff19d1116
From: Tomasz Figa <t.figa@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 07/22] ARM: dts: Remove '0x's from Exynos4210 DTSI file
Date: Wed, 24 Jul 2013 17:24:12 +0200
Message-id: <5075798.2aqxtybhC8@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <20130724150937.GO26801@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
 <20130724150937.GO26801@laptop>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xq7pzP74PNNgzh9Pi76Rj7Ba9C66y
	Wdz/epTRYk3LWxaLTY+vsVpc3jWHzWLG+X1MDuwev39NYvS4c20Pm8fmJfUefVtWMXp8X7qG
	3ePzJrkAtigum5TUnMyy1CJ9uwSujAO3H7MWHGGrmPz0NXsD4zeWLkZODgkBE4mGh4uYIGwx
	iQv31rOB2EICSxklPt1O7GLkArK7mCQWnj4P1sAmoCbxueERUBEHh4iAisS5N+YgYWaBfYwS
	r1viQGxhAT+JB8tWM4PYLAKqErN3L2AFsXkFNCXePXvGDmLzC6hLvNv2lAlkjKiAm8SEj/kg
	YU4BHYln17YxQaxdyCgxb+osJoheQYkfk++xQOySl9i3fyorhK0lsX7ncaYJjIKzkJTNQlI2
	C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghMfB1B+PSY1aHGAU4GJV4eAtnvQsU
	Yk0sK67MPcQowcGsJML79sH7QCHelMTKqtSi/Pii0pzU4kOMTBycUg2MK1/K7VzDxlOoouWt
	W1sVenV7z9ktMl9fJibWSqg7PLxowvCuLz9j/fu2+cYKOa26vQXzj312zF37tTNKcd1Tfmmp
	T9dn8UQa6M25vbpWOqVhgZ/Fz+rbpiXPv+RIZpzxPz0vcK9rQLQFZ/I9vvnh7/ckc582uc22
	8PdP6fNN3W+W7FBLNDquxFKckWioxVxUnAgARZIqY18CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 of July 2013 16:09:37 Lee Jones wrote:
> ... for the sake of consistency and assumed convention.
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> diff --git a/arch/arm/boot/dts/exynos4210.dtsi
> b/arch/arm/boot/dts/exynos4210.dtsi index b7f358a..53e2527 100644
> --- a/arch/arm/boot/dts/exynos4210.dtsi
> +++ b/arch/arm/boot/dts/exynos4210.dtsi
> @@ -72,7 +72,7 @@
>                 };
>         };
> 
> -       clock: clock-controller@0x10030000 {
> +       clock: clock-controller@10030000 {
>                 compatible = "samsung,exynos4210-clock";
>                 reg = <0x10030000 0x20000>;
>                 #clock-cells = <1>;

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

