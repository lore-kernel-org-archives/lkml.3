Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbbAVBSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:18:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57442 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbAVBSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:18:45 -0500
X-AuditID: cbfee68d-f79296d000004278-41-54c04ff228c6
Date: Thu, 22 Jan 2015 10:18:40 +0900
From: Inha Song <ideal.song@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        tiwai@suse.de, robh+dt@kernel.org, kgene@kernel.org,
        galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v2 3/3] ARM: dts: Add sound nodes for
 exynos4412-trats2
Message-id: <20150122101840.24bd93a3@songinha-Samsung-DeskTop-System>
In-reply-to: <54BFD279.7080604@samsung.com>
References: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
 <1421660902-29679-4-git-send-email-ideal.song@samsung.com>
 <54BFD279.7080604@samsung.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWyRsSkQPeT/4EQg/uL1CyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotzr1YyWvQ/fs1s8e1KB5PFpsfXWC0u75rDZjHj/D4mi9uXeS2W
	Xr/IZDFh+loWi9a9R9gtDr9pZ7W4uOILk8XLzW+YHIQ8NnxuYvNYM28No0dLcw+bx+W+XiaP
	nbPusnusXP6FzWPTqk42jzvX9rB5bF5S79G3ZRWjx+bT1R6fN8kF8ERx2aSk5mSWpRbp2yVw
	ZUxduJWl4CJnxeFHWxgbGO+wdzFyckgImEi8ffoSyhaTuHBvPVsXIxeHkMBSRokZb7YxwhS9
	ubiUCSKxiFHiQO9iFginn0niyPKXLCBVLAKqEneergSz2QQ0JL5/3swMYosI6EssWXURbCyz
	wEZmiSnz94EVCQtESRw6exJsN6+Aq8SZqdPB1nEKaEusa78IdccSRolZH+9D3WEjsXrnOmaI
	BkGJH5PvgQ1iFtCS2LytiRXClpfYvOYtM0izhMAZDonmF18YIc4TkPg2+RBQAwdQQlZi0wFm
	iJmSEgdX3GCZwCg2C8nYWUjGzkIydgEj8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwFRx
	+t+z3h2Mtw9YH2IU4GBU4uF9obg/RIg1say4MvcQoynQFROZpUST84EJKa8k3tDYzMjC1MTU
	2Mjc0kxJnFdR6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaEj7JFIa4u0eJ7bt3NCD4f
	8fVfmk3ovwizTPnjh3dVflnPMtfgrGLfyopcrWVlD34yb6jMFl/Sud3C/til1VNkfylrbaj9
	u1f20ZaMSwKGfnOsNusVys78PdnwfE/7UZZDchV7buyOuPy65WLrVlnGRrVp3cuKE8Lavkbv
	XXHL3MqU9+lb3jwlluKMREMt5qLiRABF5Mc4EAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAd1P/gdCDBbfk7G4cvEQk8XUh0/Y
	LOYfOcdq0f9mIavFgT87GC3OvVrJaNH/+DWzxbcrHUwWmx5fY7W4vGsOm8WM8/uYLG5f5rVY
	ev0ik8WE6WtZLFr3HmG3OPymndXi4oovTBYvN79hchDy2PC5ic1jzbw1jB4tzT1sHpf7epk8
	ds66y+6xcvkXNo9NqzrZPO5c28PmsXlJvUffllWMHptPV3t83iQXwBPVwGiTkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SekkJZYk4pUCggsbhYSd8O
	04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj6sKtLAUXOSsOP9rC2MB4h72LkZNDQsBE4s3FpUwQ
	tpjEhXvr2boYuTiEBBYxShzoXcwC4fQzSRxZ/pIFpIpFQFXiztOVYDabgIbE98+bmUFsEQF9
	iSWrLoJ1MwtsZJaYMn8fWJGwQJTEobMnwdbxCrhKnJk6nRHE5hTQlljXfhFq3RJGiVkf7zNC
	3GEjsXrnOmaIBkGJH5PvgQ1iFtCS2LytiRXClpfYvOYt8wRGgVlIymYhKZuFpGwBI/MqRtHU
	guSC4qT0XCO94sTc4tK8dL3k/NxNjOBE9Ex6B+OqBotDjAIcjEo8vC8U94cIsSaWFVfmHmKU
	4GBWEuH10DgQIsSbklhZlVqUH19UmpNafIjRFBgeE5mlRJPzgUkyryTe0NjEzMjSyNzQwsjY
	XEmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qBsY7xVFJZXbUX94PHNUalxQcfd6RnBX8J2NGS
	8mjHoZdB7hsWyl5eGSJ979LsmbL1rmrvj3/bNP3dvPnH8qyefG39NmeydzLLu4RiTdNtFWyn
	il7PlLedHNNTvK3B8sDSxVoJqcfvadkd8HHg1X6gVfj6X0JyVCjPDH27B3PfzmxtNoqo/GYZ
	r8RSnJFoqMVcVJwIAEVMdXZaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for your comments.

On Wed, 21 Jan 2015 17:23:21 +0100
Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:

> Hi,
> 
> On 19/01/15 10:48, Inha Song wrote:
> > --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> > +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> 
> > +	sound {
> > +		compatible = "samsung,trats2-audio";
> 
> > +		assigned-clocks = <&pmu_system_controller 0>;
> > +		assigned-clock-parents =  <&clock CLK_XUSBXTI>;
> 
> How about putting these properties in the pmu_system_controller
> node?  After all the mux clock being configured here belongs to
> the PMU subsystem. Wouldn't it work that way ?
OK, I will move assigned clock properties to pmu_system_controller DT node.

Best Regards,
Inha Song.

> 
> > +		samsung,i2s-controller = <&i2s0>;
> > +		samsung,model = "Trats2";
> > +		samsung,audio-codec = <&wm1811>;
> > +		samsung,audio-routing =
> > +			"SPK", "SPKOUTLN",
> > +			"SPK", "SPKOUTLP",
> > +			"SPK", "SPKOUTRN",
> > +			"SPK", "SPKOUTRP";
> > +	};
> 
> -- 
> Regards,
> Sylwester
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
