Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3CYKNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:13:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58555 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3CYKNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:13:40 -0400
X-AuditID: cbfee690-b7f656d0000007e3-ec-515023462cfc
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Axel Lin'" <axel.lin@ingics.com>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'John Stultz'" <john.stultz@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Changhwan Youn'" <chaos.youn@samsung.com>,
        linux-kernel@vger.kernel.org
References: <1364048887.13141.0.camel@phoenix>
 <16f801ce28f5$b9095c20$2b1c1460$%kim@samsung.com>
 <CAFRkauCDg9G3JLpB+fi3JZdu-18jr0ibFqM30tOH4rPQVO8dUQ@mail.gmail.com>
In-reply-to: <CAFRkauCDg9G3JLpB+fi3JZdu-18jr0ibFqM30tOH4rPQVO8dUQ@mail.gmail.com>
Subject: RE: [PATCH] clocksource: exynos_mct: Add terminating entry for
 exynos_mct_ids table
Date: Mon, 25 Mar 2013 19:13:26 +0900
Message-id: <177901ce2941$63c85710$2b590530$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4o9q4zcsaogIcPS6eqcVUkCjj7IgASmcRw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zA1035YBAg77ZshZH5nxltmhvULQ4
	81vX4vKuOWwWmzdNZbY4NmMJowObR9vPMo871/awebw7d47do2/LKkaPz5vkAlijuGxSUnMy
	y1KL9O0SuDKe/3UoaOWuOPvoL1MD42uOLkZODgkBE4kfC58yQdhiEhfurWfrYuTiEBJYxihx
	b9YCRpiiP20XoRKLGCWO/T7MDuH8ZZQ4vGQBO0gVm4CGxOH3z8BsEQEViTf9r5hAipgFzjNK
	TOr4wgLRsZJRYmHvKrCFnALBErv3H2EDsYUF4iRO7VwMZrMIqErM2bUQzOYVsJU4dP4aO4Qt
	KPFj8j0WEJtZQEti/c7jTBC2vMTmNW+Zuxg5gG5Vl3j0VxfiCCOJ3j3H2CBKRCT2vXjHCHKD
	hMA9dombTS0sELsEJL5NPsQC0SsrsekAM8TLkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlW
	MYqmFiQXFCelF5noFSfmFpfmpesl5+duYoRE7IQdjPcOWB9iTAZaP5FZSjQ5HxjxeSXxhsZm
	RhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgNEi7pVav1rvj
	Ytc804980Wp+sxd5flk/Ic/oJ2vS0sOrgtR/X65nlNe/lzxb/Pbplxq+0dJfrrmblD86/HJm
	tJYfw3G+9/zThDL+Lp9cM+Oq5qa7CgfrEvPy3GP3XorhW3lBSLEuwfOrGVPazrDU7l/hBqvC
	Vkde/P30c+iFi4FpXVrWIUIzlFiKMxINtZiLihMBN1GXAO4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAV035YBAgz//JSyOzPnKbNHeoGhx
	5reuxeVdc9gsNm+aymxxbMYSRgc2j7afZR53ru1h83h37hy7R9+WVYwenzfJBbBGNTDaZKQm
	pqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDtV1IoS8wpBQoF
	JBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmPP/rUNDKXXH20V+mBsbXHF2MnBwSAiYS
	f9ouskHYYhIX7q0Hsrk4hAQWMUoc+32YHcL5yyhxeMkCdpAqNgENicPvn4HZIgIqEm/6XzGB
	FDELnGeUmNTxhQWiYyWjxMLeVUwgVZwCwRK79x8B2yEsECdxaudiMJtFQFVizq6FYDavgK3E
	ofPX2CFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nL3MXIAXSrusSjv7oQRxhJ9O45xgZRIiKx
	78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4HTyT
	2sG4ssHiEKMAB6MSD69AjX+gEGtiWXFl7iFGCQ5mJRFeLaGAQCHelMTKqtSi/Pii0pzU4kOM
	yUCPTmSWEk3OB6aqvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLg
	lGpgPLFSNZtb9FFgklkp85XOPVOfTtT1TUot3eB1uVz/0Wk/GeGDhn9unXfdzyFW5SpUr+qx
	RjtI38l/QZV6+7W/ydv8bJ2m7Lzjdnab6HqfZdUH1JwuzvFyVYmzm/dyz/HNRwpVt/TJHnyn
	Zezea7U2hjs/ZEp49seCGdbnUtQdz7F1fP7bO69ZiaU4I9FQi7moOBEAtb4BVUsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> 
> 2013/3/25 Kukjin Kim <kgene.kim@samsung.com>:
> > Axel Lin wrote:
> >>
> >> The of_device_id table is supposed to be zero-terminated.
> >>
> >> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> >> ---
> >>  drivers/clocksource/exynos_mct.c |    1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/clocksource/exynos_mct.c
> >> b/drivers/clocksource/exynos_mct.c
> >> index 203ac05..3cdafc0 100644
> >> --- a/drivers/clocksource/exynos_mct.c
> >> +++ b/drivers/clocksource/exynos_mct.c
> >> @@ -514,6 +514,7 @@ static void __init exynos4_timer_resources(struct
> >> device_node *np)
> >>  static const struct of_device_id exynos_mct_ids[] = {
> >>       { .compatible = "samsung,exynos4210-mct", .data = (void
> >> *)MCT_INT_SPI },
> >>       { .compatible = "samsung,exynos4412-mct", .data = (void
> >> *)MCT_INT_PPI },
> >> +     { }
> >
> > Thanks for your pointing out. But as I know, it is not mandatory now.
> >
> > Please correct me if I'm wrong.
> 
> of_find_matching_node_and_match()
> -> __of_match_node()
>     while (matches->name[0] || matches->type[0] || matches->compatible[0])
> 
> My understanding is the implementation in _of_match_node() still needs
> zero-terminated entry to break out the while loop.

OK, you're right. In this case, a null entry is required in
__of_match_node().

Thanks, applied.

- Kukjin

