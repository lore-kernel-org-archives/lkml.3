Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967037Ab3HIAsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:48:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16807 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966966Ab3HIAsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:48:43 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-e5-52043c696a08
Date: Fri, 09 Aug 2013 09:48:41 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 05/16] clk: exynos: add gate clock descriptions of
 System MMU
Message-id: <20130809094841.98ccbe2202e3bb2dab9f5220@samsung.com>
In-reply-to: <1673985.XNpTEeH9vo@amdc1227>
References: <002901ce941b$0130db50$039291f0$@samsung.com>
 <52037E4E.5050706@samsung.com> <1673985.XNpTEeH9vo@amdc1227>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zI91MG5Ygg11TTS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxeE3
	7awWJ//0Mlq0XO9lslg/4zWLg4DHk4PzmDxmN1xk8bhzbQ+bx/lNa5g9Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOKyyYlNSezLLVI3y6BK+PQ0jlsBR8EK+a/fcTcwPiPt4uRk0NCwETi
	RutxJghbTOLCvfVsXYxcHEICyxglVvSfAnI4wIo2tvtDxKczSrz+e4oFwpnEJDH/2CJGkG4W
	AVWJj+8egtlsAloSq+ceB7NFBFQkLp+aDmYzCyxnlfgzVwrEFhYIkzhxqJMNxOYVcJS48+AR
	M8gyTqDez6vyQMJCAhUSbY+OsEIcZyFxoamDHaJcUOLH5HssECO1JDZva2KFsOUlNq95ywxy
	m4TASg6JKfsfskPcJiDxbfIhFohnZCU2HWCGmCkpcXDFDZYJjGKzkIydhWTsLCRjFzAyr2IU
	TS1ILihOSi8y1CtOzC0uzUvXS87P3cQIifneHYy3D1gfYkwGWjmRWUo0OR+YMvJK4g2NzYws
	TE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOg7a6nlA3HmPae+
	JE8/f+OsbNbPR5xFvsnCO6/fvnT37rolOdITLR+s57qf9SjPfWZJvkjVpZLyuDJ2TZ+Fqlez
	vILMHjG9nCca+6Y6tvmD8Oqmi2Zb2buMo1iPJZ3pDbJ1mXtl0deTH/XqudcbLp+oOYv1q+XP
	9abBCuIfr3f8SPO3yvebmaTEUpyRaKjFXFScCACgZkZfDwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jQd1MG5Ygg5W39Czu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxeE3
	7awWJ//0Mlq0XO9lslg/4zWLg4DHk4PzmDxmN1xk8bhzbQ+bx/lNa5g9Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gNJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGoaVz
	2Ao+CFbMf/uIuYHxH28XIweHhICJxMZ2/y5GTiBTTOLCvfVsXYxcHEIC0xklXv89xQLhTGKS
	mH9sESNIFYuAqsTHdw/BbDYBLYnVc4+D2SICKhKXT00Hs5kFlrNK/JkrBWILC4RJnDjUyQZi
	8wo4Stx58IgZZDEnUO/nVXkgYSGBCom2R0dYIY6wkLjQ1MEOUS4o8WPyPRaIkVoSm7c1sULY
	8hKb17xlnsAoMAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxQnknv
	YFzVYHGIUYCDUYmHV3E7c5AQa2JZcWXuIUYJDmYlEd4XWUAh3pTEyqrUovz4otKc1OJDjMnA
	wJjILCWanA9Mdnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wLiycsEi3y/Mb/SsXm+43tTm/Xj6jYirjN5M6dbm+1I5Hgsaqd9NyHtzk2H3rohlypunc4pq
	BkhO0ncOvXj3rIqOTy1/F2vIhx/F03szM3+bJZeInSlft+Pdj6oJM1wefZldofpMau7zY5vN
	Xm279PDB1gs1bS+z3/hcvHDXUCpEtnTdprkv3dKVWIozEg21mIuKEwEOoe7bbAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013 13:40:13 +0200, Tomasz Figa wrote:

> On Thursday 08 of August 2013 13:17:34 Sylwester Nawrocki wrote:
> > On 08/08/2013 11:38 AM, Cho KyongHo wrote:
> > > This adds gate clocks of all System MMUs and their master IPs
> > > that are not apeared in clk-exynos5250.c
> > > Also fixes GATE_IP_ACP to 0x18800 and changed GATE_DA to GATE
> > > for System MMU clocks in clk-exynos4.c
> > > 
> > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > ---
> > > 
> > >  .../devicetree/bindings/clock/exynos5250-clock.txt |   26 +++++++++
> > >  drivers/clk/samsung/clk-exynos4.c                  |   27 +++------
> > >  drivers/clk/samsung/clk-exynos5250.c               |   57
> > >  ++++++++++++++++---- 3 files changed, 82 insertions(+), 28
> > >  deletions(-)
> > 
> > [...]
> > 
> > > @@ -349,19 +358,26 @@ static struct samsung_gate_clock
> > > exynos5250_gate_clks[] __initdata = {> 
> > >  	GATE(gscl3, "gscl3", "aclk266", GATE_IP_GSCL, 3, 0, 0),
> > >  	GATE(gscl_wa, "gscl_wa", "div_gscl_wa", GATE_IP_GSCL, 5, 0, 0),
> > >  	GATE(gscl_wb, "gscl_wb", "div_gscl_wb", GATE_IP_GSCL, 6, 0, 0),
> > > 
> > > -	GATE(smmu_gscl0, "smmu_gscl0", "aclk266", GATE_IP_GSCL, 7, 0, 0),
> > > -	GATE(smmu_gscl1, "smmu_gscl1", "aclk266", GATE_IP_GSCL, 8, 0, 0),
> > > -	GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
> > > -	GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
> > > +	GATE(smmu_gscl0, "smmu_gscl0", "none", GATE_IP_GSCL, 7, 0, 0),
> > > +	GATE(smmu_gscl1, "smmu_gscl1", "none", GATE_IP_GSCL, 8, 0, 0),
> > > +	GATE(smmu_gscl2, "smmu_gscl2", "none", GATE_IP_GSCL, 9, 0, 0),
> > > +	GATE(smmu_gscl3, "smmu_gscl3", "none", GATE_IP_GSCL, 10, 0, 0),
> > 
> > Why are the smmu clocks' parent clocks removed ? Shouldn't both the
> > gscaler gate clock and the gscaler smmu clock be still same, as it is in
> > case of exynos4 ?
> 
> I agree with Sylwester.
> 
> In fact, it is not a valid clock setup. A valid clock must be either root 
> clock (indicated by appropriate clock flag and specified frequency) or have 
> a valid parent.
> 

I thought that it does not require parent clock since it is just a gating clock.
Let me check it again.

Thank you.
> Best regards,
> Tomasz
> 
