Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3G2HUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:20:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21182 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3G2HUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:20:31 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-0b-51f617bcb126
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
 <CAK9yfHy2btp1W+5-GiVQnkffDnJ-CgqXuAjGktkiKYyf7kKQbQ@mail.gmail.com>
In-reply-to: <CAK9yfHy2btp1W+5-GiVQnkffDnJ-CgqXuAjGktkiKYyf7kKQbQ@mail.gmail.com>
Subject: RE: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Date: Mon, 29 Jul 2013 16:20:28 +0900
Message-id: <003701ce8c2c$19eff910$4dcfeb30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQJ8iaVttThmxHyrdfHNT5d6MXLI1gKK1rNQmArt9KA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t8zfd094t8CDS50SlncuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzigum5TUnMyy1CJ9uwSujKvt/YwFX9grJt+8xtjA+Je1i5GTQ0LAROJx2xsW
	CFtM4sK99WxdjFwcQgLLGCXOLP3PCFN0bls3VGI6o8SlbZtZIZy/jBLHlq1nB6liE9CSWD33
	OFiHiICOxIpda5lAipgFelglfv+cA9XewCixctYxNpAqToFgiTVfN4EtFxYIk9h7Yz1YnEVA
	VWJXyySwA3kFLCWe7znHDGELSvyYfA+snhlo2/qdx5kgbHmJzWveMkPcqiCx4+xrRoi4iMS+
	F++gLrKSOPbiJtgREgIHOCR23DvGCLFMQOLb5ENAQzmAErISmw5AzZGUOLjiBssERolZSFbP
	QrJ6FpLVs5CsW8DIsopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJHH07mC8fcD6EGMy0PqJ
	zFKiyfnAxJNXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBka2r7z9K7isIjk3XXIy7mvJTl8Z1Ndz6ZB+4YtU1bcpP2OK152r3nrfp02b+xXb7uh5
	Pz9Nvc7n7M+ctOngUrdFQfxT/Ba+C79k8XCTxbzIvMqUsG9qB/b+ctGcnZ71xLnB10Nm4jmL
	p/MklZYWRXO4ZleVZFz3v2u8WZVj/6SmTxmvltzwu6/EUpyRaKjFXFScCACzjTNtMgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t9jQd094t8CDd5dF7G4c/ccq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWF1ZsZLeY
	sugwq8XJP72MFi3Xe5kc+D2eHJzH5DG74SKLx51re9g8zm9aw+yxeUm9x+Qbyxk9+rasYvT4
	vEnO48rRM0wBnFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOutvczFnxh
	r5h88xpjA+Nf1i5GTg4JAROJc9u62SBsMYkL99YD2VwcQgLTGSUubdvMCuH8ZZQ4tmw9O0gV
	m4CWxOq5xxlBbBEBHYkVu9YygRQxC/SwSvz+OQeqvYFRYuWsY2BzOQWCJdZ83cQCYgsLhEns
	vbEeLM4ioCqxq2US2B28ApYSz/ecY4awBSV+TL4HVs8MtG39zuNMELa8xOY1b5khblWQ2HH2
	NSNEXERi34t3UBdZSRx7cZNtAqPQLCSjZiEZNQvJqFlI2hcwsqxiFE0tSC4oTkrPNdQrTswt
	Ls1L10vOz93ECE5Lz6R2MK5ssDjEKMDBqMTD+9DpS6AQa2JZcWXuIUYJDmYlEV4Oo6+BQrwp
	iZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTJl5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJI
	TyxJzU5NLUgtgtnCxMEp1cAYumW9YnHBh0078uuzIk5+ehh/UPK0b9ntm8tW+U7QWOC0o8Hr
	ziTmzS9C2VtkauTShZpPOwndl9/B+axD/UHa1msKLNUH2nPfv+Ka4ZW3SimhtGb2t/Sv3tob
	cxMkgo0Cn1fMSJpd8TvnqPFV/ya/6NTcOt6gWV46t6aL7JLe1P3v7uujdoeVWIozEg21mIuK
	EwEbVgzTjwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Monday, July 29, 2013 3:38 PM
> 
> Hi KyongHo,
> 
> On 26 July 2013 16:58, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
> >  arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++++++++++++++++
> >  5 files changed, 617 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> 
> This patch does not apply on the mainline Linus' tree (3.11-rc2). Please rebase.
> 

OK. I will rebase the next patches on that.

Thank you.

Cho KyongHo. 
> --
> With warm regards,
> Sachin

