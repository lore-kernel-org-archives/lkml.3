Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaGaBKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 21:10:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11254 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaGaBKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 21:10:13 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-a3-53d997724295
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>
Cc: "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org,
        "'Tarek Dakhran'" <t.dakhran@samsung.com>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1406463725-4208-1-git-send-email-afaerber@suse.de>
 <53D4EFBB.6000404@suse.de> <00c901cfa9fc$727b4e10$5771ea30$@samsung.com>
 <CAOesGMjh=xMZ3vB45ofh=CLjTFDMQxSxus5q_P67XQSbwg6-+A@mail.gmail.com>
In-reply-to: <CAOesGMjh=xMZ3vB45ofh=CLjTFDMQxSxus5q_P67XQSbwg6-+A@mail.gmail.com>
Subject: RE: [PATCH 0/3] ARM: EXYNOS: Fix Exynos5410 boot
Date: Thu, 31 Jul 2014 10:10:09 +0900
Message-id: <03f501cfac5c$2c69be90$853d3bb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGL1z+9jtB2rTxYt9Lq23w+zrC3BgJGVL7mAfqrOokBq517gZwRomvA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zfd2i6TeDDY5MYLdo3lRs8fXwCkaL
	TY+vsVpc3jWHzWLG+X1MFqeuf2azWLT1C7vF+uenGC3Wz3jN4sDpcefaHjaPzUvqPa6caGL1
	6NuyitFj8+lqj8+b5ALYorhsUlJzMstSi/TtErgyVj6cylqwgadi+fwWtgbGeZxdjJwcEgIm
	EvNnPGeDsMUkLtxbD2RzcQgJLGOUWDtlFTtM0dPpx6AS0xkllm+dAuX8ZZS4Nv0FE0gVm4CG
	xOH3z8A6RARUJZ486WIFKWIWOMIk8X36HCaIjouMEq+nLGQFqeIUCJboPLsJrENYwFJi0t8l
	jCA2C1D3pXltLCA2L1D8y8knrBC2oMSPyffA4swC6hKT5i1ihrC1JZ68u8AKcauCxI6zr4Hm
	cABd4SbRfyECokREYt+Ld4wgN0gI/GSX6DlxiAlil4DEt8mHWEDqJQRkJTYdYIYYIylxcMUN
	lgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIbPfuYLx9
	wPoQYzLQ+onMUqLJ+cDUkFcSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjHP2Mrg845Y5ae/P+W/VspuPqjOllxzoUL5TeG6pZtSsLx7qgg8aY865
	vf7LZjJ7Ict7Ex6l/s+b5jKeVDRWnLz+UXxEz4bzTelnFbwOrO+OrQhIuam169+SXU8Mbod7
	TqueK5Xlrp4TGCpxTkybaetio5BSm6KD/4tOecqzGTPJf3/lvlpxjhJLcUaioRZzUXEiALan
	rSEDAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd2i6TeDDT4+YLJo3lRs8fXwCkaL
	TY+vsVpc3jWHzWLG+X1MFqeuf2azWLT1C7vF+uenGC3Wz3jN4sDpcefaHjaPzUvqPa6caGL1
	6NuyitFj8+lqj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOAblJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZqx8
	OJW1YANPxfL5LWwNjPM4uxg5OSQETCSeTj/GBmGLSVy4tx7I5uIQEpjOKLF86xQo5y+jxLXp
	L5hAqtgENCQOv3/GDmKLCKhKPHnSxQpSxCxwhEni+/Q5TBAdFxklXk9ZyApSxSkQLNF5dhNY
	h7CApcSkv0sYQWwWoO5L89pYQGxeoPiXk09YIWxBiR+T74HFmQXUJSbNW8QMYWtLPHl3gRXi
	VgWJHWdfA83hALrCTaL/QgREiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgxPFMagfjygaLQ4wCHIxKPLw/TG4GC7EmlhVX5h5ilOBgVhLh
	7fIECvGmJFZWpRblxxeV5qQWH2I0BXp0IrOUaHI+MKnllcQbGpuYGVkamVkYmZibK4nzHmi1
	DhQSSE8sSc1OTS1ILYLpY+LglGpgPHTjsEFLl85n2eduipY686ce/uj1hWvWr+f8s+X0qz1v
	mUS6f7PdeIMldLWyxzzJkIPqE0LWS3OKZXO+jnlw9a7x+1TJdw1+62PW+pbMLNa0YJ4/N9Dr
	q//bhiUXxSVz+J/LvNl4fcnpf6FrrrJsu6q/886uF9t8NkjmNeafy1W3kjh7ZHbWCyWW4oxE
	Qy3mouJEAKej+SwyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> Hi,
> 
Hi Olof,

> On Sun, Jul 27, 2014 at 5:39 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Andreas Färber wrote:
> >>
> >> Am 27.07.2014 14:22, schrieb Andreas Färber:
> >> > Hello,
> >> >
> >> > This mini-series unbreaks booting on 5410 based ODROID-XU.
> >> >
> >> > Since I do not have access to a TRM, the address is a guess based on
> >> > 5250 and 5410. Such a node was not present in the 3.14 downstream tree.
> >>
> >> s/5410/5420/
> >>
> > OK.
> >
> >> >
> >> > Regards,
> >> > Andreas
> >> >
> >> > Andreas Färber (3):
> >> >   Documentation: devicetree: Document exynos5410 PMU
> >> >   ARM: dts: exynos: Add PMU to Exynos5410
> >> >   ARM: EXYNOS: Add support for Exynos5410 PMU
> >> >
> >> >  Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
> >> >  arch/arm/boot/dts/exynos5410.dtsi                     | 5 +++++
> >> >  arch/arm/mach-exynos/exynos.c                         | 1 +
> >> >  3 files changed, 7 insertions(+)
> >>
> > Andreas, thanks.
> >
> > I'll apply this whole series.
> 
> We're getting close to the merge window. I'd prefer not to have to
> start reverting samsung code to recover from these regressions, so
> please send this up very soon.
> 
Thanks for your gentle reminder.

BTW I'm waiting for exynos5250-spring support from Andreas and I'd like to get
confirmation about that from Doug. And I'm looking at s2r related patches now.

OK, I will send out current samsung tree tonight in my time anyway.

- Kukjin

