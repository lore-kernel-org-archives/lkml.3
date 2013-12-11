Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab3LKWYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:24:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18494 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3LKWYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:24:50 -0500
X-AuditID: cbfee690-b7f676d00000310d-67-52a8e6306705
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Jason Cooper'" <jason@lakedaemon.net>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Simon Horman'" <horms@verge.net.au>,
        "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Valentine Barshak'" <valentine.barshak@cogentembedded.com>,
        "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Kuninori Morimoto'" <kuninori.morimoto.gx@renesas.com>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20131211183237.GI4699@google.com>
 <20131211184321.GJ4699@google.com>
In-reply-to: <20131211184321.GJ4699@google.com>
Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada,
 R-Car PCI host maintainers
Date: Thu, 12 Dec 2013 07:24:47 +0900
Message-id: <000f01cef6bf$cd0fe340$672fa9c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac72oOLDM71EYw9eQ8OWHSuWMlHqsQAHjYAA
Content-language: ko
x-cr-hashedpuzzle: bo29 hxzC +DSn AEah2A== AFz6Iw== AJgbpg== AKuUmg== AMAn+A==
 ASvTxQ== ATazlw== ATcVAA== AWCqSQ== AWjJ6w== AjsVtw== AlmDFA==
 AoraCw==;19;YgBoAGUAbABnAGEAYQBzAEAAZwBvAG8AZwBsAGUALgBjAG8AbQA7AGgAbwByAG0AcwBAAHYAZQByAGcAZQAuAG4AZQB0AC4AYQB1ADsAagBhAHMAbwBuAEAAbABhAGsAZQBkAGEAZQBtAG8AbgAuAG4AZQB0ADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGsAdQBuAGkAbgBvAHIAaQAuAG0AbwByAGkAbQBvAHQAbwAuAGcAeABAAHIAZQBuAGUAcwBhAHMALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGEAcgBtAC0AawBlAHIAbgBlAGwAQABsAGkAcwB0AHMALgBpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHAAYwBpAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBzAGEAbQBzAHUAbgBnAC0AcwBvAGMAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHMAaABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AdABlAGcAcgBhAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGEAZwBuAHUAcwAuAGQAYQBtAG0AQABnAG0AYQBpAGwALgBjAG8AbQA7AG0AbwBoAGkAdAAuAGsAdQBtAGEAc
	gBAAHMAdAAuAGMAbwBtADsAcAByAGEAdAB5AHUAcwBoAC4AYQBuAGEAbgBkAEAAcwB0AC4AYwBvAG0AOwBzAGgAYQB3AG4ALgBnAHUAbwBAAGwAaQBuAGEAcgBvAC4AbwByAGcAOwB0AGgAaQBlAHIAcgB5AC4AcgBlAGQAaQBuAGcAQABnAG0AYQBpAGwALgBjAG8AbQA7AHYAYQBsAGUAbgB0AGkAbgBlAC4AYgBhAHIAcwBoAGEAawBAAGMAbwBnAGUAbgB0AGUAbQBiAGUAZABkAGUAZAAuAGMAbwBtADsAdwBlAGkAeQBqAC4AbABrAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwB5AG8AbgBnAGoAdQBuAF8AdwBlAGkAQAB0AHIAZQBuAGQAbQBpAGMAcgBvAC4AYwBvAG0ALgBjAG4A;Sosha1_v1;7;{B4A3A1B0-26AE-4D3D-9631-BE940CF14BB4};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 11 Dec 2013 22:24:10
 GMT;UgBlADoAIABbAFAAQQBUAEMASABdACAATQBBAEkATgBUAEEASQBOAEUAUgBTADoAIABBAGQAZAAgAEQAZQBzAGkAZwBuAFcAYQByAGUALAAgAGkALgBNAFgANgAsACAAQQByAG0AYQBkAGEALAAgAFIALQBDAGEAcgAgAFAAQwBJACAAaABvAHMAdAAgAG0AYQBpAG4AdABhAGkAbgBlAHIAcwA=
x-cr-puzzleid: {B4A3A1B0-26AE-4D3D-9631-BE940CF14BB4}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsVy+t8zI12DZyuCDPaukbZY0pRh8fKQpkXz
	1q+MFo1LLrNYXF54idXi1eFdjBabHl9jtbi8aw6bxdl5x9ksZpzfx2Qx588UZovOL7PYLB6s
	fstmsXHqL0aL9kvKFk/XLWG2+LlrHovF8nsnmSw+XDrKbLFzXSe7g4jHg6n/mTx2zrrL7rFg
	U6lHw4HzLB53ru1h89i8pN7j25mJLB59W1Yxejz9sZfZY+m9o4wec35+Y/H4vEkugCeKyyYl
	NSezLLVI3y6BK+PK7O0sBWvFKlZMnc3cwDhfqIuRk0NCwESi9eQsZghbTOLCvfVsXYxcHEIC
	yxglti59zwxTtKP3CitEYhGjxKGVi9khnF+MEg8XvwarEhbwk2iaMwnMZhNQk/jy5TA7iC0i
	4CJx5OgUFpAGZoHNrBLfPn0HSwgJBEss/nKJDcTmFNCXuN6wiQ1iUKzE24Y3YDaLgKrEo+n7
	WUBsXgFbiWPdO9ggbEGJH5PvgcWZBbQk1u88zgRhy0tsXvMW6AgOoLPVJR791YW4wUhi+e9e
	RogSEYl9L94xQnw2g0/i09kqCNtU4uqxdrDHJATmc0osfLqLCeIGAYlvkw+xQMyUldh0ABoq
	khIHV9xgmcAoPQvJRbOQXDQLyUWzkKxewMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMk
	jU3YwXjvgPUhxmSg9ROZpUST84FpMK8k3tDYzMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZ
	qakFqUXxRaU5qcWHGJk4OKUaGNtEmP/snzEvJUVrpt2UWq4Xxb/emSmsK6lOn/rij5nFO5ti
	X7/QACXRR+8nXXE8vy/kG98knzOBC4V0t15VEmQsNNuyWjcqpPqHpuzUPaUXGr53nkzZy9ey
	szUt9H0o37Vdj5afbRedcrgx4syne7OfX/KYefC70rq2Qx12D9eFMPdUvLyZY6nEUpyRaKjF
	XFScCABNhhXKeQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsVy+t9jAV2DZyuCDI60ilgsacqweHlI06J5
	61dGi8Yll1ksLi+8xGrx6vAuRotNj6+xWlzeNYfN4uy842wWM87vY7KY82cKs0Xnl1lsFg9W
	v2Wz2Dj1F6NF+yVli6frljBb/Nw1j8Vi+b2TTBYfLh1ltti5rpPdQcTjwdT/TB47Z91l91iw
	qdSj4cB5Fo871/aweWxeUu/x7cxEFo++LasYPZ7+2MvssfTeUUaPOT+/sXh83iQXwBPVwGiT
	kZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SmkkJZYk4p
	UCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHjyuztLAVrxSpWTJ3N3MA4X6iLkZND
	QsBEYkfvFVYIW0ziwr31bF2MXBxCAosYJQ6tXMwO4fxilHi4+DUzSJWwgJ9E05xJYDabgJrE
	ly+H2UFsEQEXiSNHp7CANDALbGaV+PbpO1hCSCBYYvGXS2wgNqeAvsT1hk1sEINiJd42vAGz
	WQRUJR5N388CYvMK2Eoc697BBmELSvyYfA8sziygJbF+53EmCFteYvOat0BHcACdrS7x6K8u
	xA1GEst/9zJClIhI7HvxjhHisxl8Ep/OVkHYphJXj7WzT2AUnYVkwywkG2Yh2TALyagFjCyr
	GEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKT5DPpHYyrGiwOMQpwMCrx8L44uCJIiDWxrLgy
	9xCjBAezkgjvjiNAId6UxMqq1KL8+KLSnNTiQ4zJwACYyCwlmpwPTOB5JfGGxiZmRpZGZhZG
	JubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBoLRi/Wjhu7vkJRj2y1i/4pr9b+UA6
	meuEPadN4OUqm92q26Zfj9bwFhfME192cIL6Vds59kYeKRXp13jn6T9RYZ90W272R1EtDjsZ
	SxlFzftphm4Vsy6/rLm5UqaA6/LM9dpnDR4vFn0gtb24UaY3xop12/35gtwPxK3NtvEoX7KW
	L/JYc1GJpTgj0VCLuag4EQBhNF241gMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 12, 2013 3:43 AM, Bjorn Helgaas wrote:
> On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> > If this looks reasonable, I'll merge it via the PCI tree for v3.13.
> 
> And I see Mohit's patch [1] to update the DesignWare entry:
> 
> +PCIE DRIVER FOR SYNOPSIS DESIGNWARE CONTROLLER
> +M:	Mohit Kumar <mohit.kumar@st.com>
> +M:	Jingoo Han <jg1.han@samsung.com>
> +L:	linux-pci@vger.kernel.org
> +S:	Maintained
> +F:	drivers/pci/host/pcie-designware.c
> 
> I can fold in that update too if Jingoo acks it.
> 
> [1] http://patchwork.ozlabs.org/patch/299905/

Hi Bjorn,

I agree with this. :-)
Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> > MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers
> >
> > Add entries for PCI host controller drivers in drivers/pci/host/.
> >
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > ---
> >  MAINTAINERS |   31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 8285ed4676b6..826c722d92ba 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6449,16 +6449,47 @@ F:	drivers/pci/
> >  F:	include/linux/pci*
> >  F:	arch/x86/pci/
> >
> > +PCI DRIVER FOR DESIGNWARE
> > +M:	Jingoo Han <jg1.han@samsung.com>
> > +L:	linux-pci@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/pci/host/*designware*
> > +
> > +PCI DRIVER FOR IMX6
> > +M:	Shawn Guo <shawn.guo@linaro.org>
> > +L:	linux-pci@vger.kernel.org
> > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +S:	Maintained
> > +F:	drivers/pci/host/*imx6*
> > +
> > +PCI DRIVER FOR MVEBU (Marvell Armada 370 and Armada XP SOC support)
> > +M:	Jason Cooper <jason@lakedaemon.net>
> > +L:	linux-pci@vger.kernel.org
> > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +S:	Maintained
> > +F:	drivers/pci/host/*mvebu*
> > +
> >  PCI DRIVER FOR NVIDIA TEGRA
> >  M:	Thierry Reding <thierry.reding@gmail.com>
> >  L:	linux-tegra@vger.kernel.org
> > +L:	linux-pci@vger.kernel.org
> >  S:	Supported
> >  F:	Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> >  F:	drivers/pci/host/pci-tegra.c
> >
> > +PCI DRIVER FOR RENESAS R-CAR
> > +M:	Simon Horman <horms@verge.net.au>
> > +M:	Magnus Damm <magnus.damm@gmail.com>
> > +L:	linux-pci@vger.kernel.org
> > +L:	linux-sh@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/pci/host/*rcar*
> > +
> >  PCI DRIVER FOR SAMSUNG EXYNOS
> >  M:	Jingoo Han <jg1.han@samsung.com>
> >  L:	linux-pci@vger.kernel.org
> > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
> >  S:	Maintained
> >  F:	drivers/pci/host/pci-exynos.c
> >

