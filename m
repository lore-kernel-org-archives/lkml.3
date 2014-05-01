Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaEAOQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:16:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18557 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaEAOQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:16:29 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-99-5362573b9ea1
Date: Thu, 01 May 2014 23:16:26 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Vikas Sajjan <sajjan.linux@gmail.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>, joro@8bytes.org,
        supash.ramaswamy@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        sunil joshi <joshi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, Varun.Sethi@freescale.com,
        a.motakis@virtualopensystems.com, Tomasz Figa <t.figa@samsung.com>,
        RAHUL SHARMA <rahul.sharma@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH v12 30/31] ARM: dts: add System MMU nodes of exynos5250
Message-id: <20140501231626.fd15cca4a30891f81c953a44@samsung.com>
In-reply-to: <CAD=FV=UCpQRg9nWu5EfuzWmBpee9N3X6yCmtpRaNQxitfFZkMQ@mail.gmail.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <1398584283-22846-31-git-send-email-shaik.ameer@samsung.com>
 <CAGm_ybhTEN9QxFBd1Su8NGP32KeYTF8d_Z8gXKo7cYpapZrA9w@mail.gmail.com>
 <CAD=FV=UCpQRg9nWu5EfuzWmBpee9N3X6yCmtpRaNQxitfFZkMQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t8zY13r8KRgg8VzZCwer1nMZHHn7jlW
	i/lHgMTZZQfZLF4d+cFksWC/tUXn7A3sFt93fWG36F1wlc1i0+NrrBaXd81hs5hxfh+TxYUV
	G9ktpiw6zGpx+E07q8XJP72MFk8Of2S1OPJwN7tFy/VeJov1M16zWKza9YfRYuatNSwOYh5P
	Ds5j8pjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4orhs
	UlJzMstSi/TtErgyHvTtYyv4Iljx6tUW1gbG47xdjJwcEgImEjs2NrND2GISF+6tZ+ti5OIQ
	EljGKDGv/y4LTNHnXZ1sILaQwCJGiUVvPSGKJjNJ3J7bANTNwcEioCoxeZ8dSA2bgJbE6rnH
	GUFsEQFNiWcNL5lB6pkFGtglNrfOA9smLOAtsfPpPVYQm1fAUWLL8TfMIDanQLDE69nTWSAW
	TGGSWPCnkRHiCguJC00d7BANghI/Jt8Du44ZaNvmbU2sELa8xOY1b8G2SQg84ZD49rwXLMEi
	ICDxbfIhFpBLJQRkJTYdYIaYKSlxcMUNlgmMYrOQjJ2FZOwsJGMXMDKvYhRNLUguKE5KLzLS
	K07MLS7NS9dLzs/dxAhJHn07GG8esD7EmAy0ciKzlGhyPjD55JXEGxqbGVmYmpgaG5lbmpEm
	rCTOu+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRkdrRpa/It3O9csDkhRqf7s7ycsx
	9RYnbDqxIZJ785Psjueaa/37Z0iyiXSmOuk2K+6fMKHKbN7ZZTq3apbKPJ1oZa4hfm25z/WY
	jPb8do9T7vzJL6bUzKpZFH/F6nj6G//V5rJ/v6qdCngV8259emjArofLvV/n96ofi/vj4rp8
	1l5e5u79SizFGYmGWsxFxYkAfLaXZjQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t9jAV3r8KRgg4Z9ohaP1yxmsrhz9xyr
	xfwjQOLssoNsFq+O/GCyWLDf2qJz9gZ2i++7vrBb9C64ymax6fE1VovLu+awWcw4v4/J4sKK
	jewWUxYdZrU4/Kad1eLkn15GiyeHP7JaHHm4m92i5Xovk8X6Ga9ZLFbt+sNoMfPWGhYHMY8n
	B+cxecxuuMji8e9wP5PHzll32T3uXNvD5rF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEzTAFcUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAnyoplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMx707WMr+CJY8erVFtYGxuO8XYyc
	HBICJhKfd3WyQdhiEhfurQezhQQWMUoseuvZxcgFZE9mkrg9t4G9i5GDg0VAVWLyPjuQGjYB
	LYnVc48zgtgiApoSzxpeMoPUMws0sEtsbp3HDpIQFvCW2Pn0HiuIzSvgKLHl+BtmEJtTIFji
	9ezpLBALpjBJLPjTyAhxhYXEhaYOdogGQYkfk++xgNjMQNs2b2tihbDlJTavecs8gVFgFpKy
	WUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjODU9k97BuKrB4hCjAAejEg/v
	BLbEYCHWxLLiytxDjBIczEoivPPUkoKFeFMSK6tSi/Lji0pzUosPMSYDg2Mis5Rocj4wbeaV
	xBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+P0c7ft2lbPKAxT
	1jH9YVpvv+iN58oX0uei478y+TFduuswL1WZ4dVPUR0n5uwdS2y9eJaumBMz45igUsAPc5m0
	DfEZd8o5kqbd/qPbmFRxxKAs/0GB57w1Bhs6P10/90563tV3s3ut42J1t2nI26kI/ci5yMCY
	pjJpwtVjt5cYzv/7SyDzx28lluKMREMt5qLiRACVrTRMkQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 16:13:19 -0700, Doug Anderson wrote:
> Vikas,
> 
> 
> On Sun, Apr 27, 2014 at 10:39 AM, Vikas Sajjan <sajjan.linux@gmail.com> wrote:
> > Hi shaik,
> >
> > +Doug, Abhilash,
> >
> > On Sun, Apr 27, 2014 at 1:08 PM, Shaik Ameer Basha
> > <shaik.ameer@samsung.com> wrote:
> >> From: Cho KyongHo <pullip.cho@samsung.com>
> >>
> >> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >> ---
> >>  arch/arm/boot/dts/exynos5250.dtsi |  270 ++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 267 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> >> index 3742331..eebd397 100644
> >> --- a/arch/arm/boot/dts/exynos5250.dtsi
> >> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> >> @@ -82,6 +82,16 @@
> >>                 reg = <0x10044040 0x20>;
> >>         };
> >>
> >> +       pd_isp: isp-power-domain@0x10044020 {
> >> +               compatible = "samsung,exynos4210-pd";
> >> +               reg = <0x10044020 0x20>;
> >> +       };
> >> +
> >> +       pd_disp1: disp1-power-domain@0x100440A0 {
> >> +               compatible = "samsung,exynos4210-pd";
> >> +               reg = <0x100440A0 0x20>;
> >> +       };
> >> +
> >
> > As per subject "add System MMU nodes of exynos5250", it should only
> > add SysMMU node.
> > So, I think adding power domain nodes should go in a separate patch.
> >
> > Adding power domain nodes can break the system, if powering ON/OFF of
> > the given power domain is NOT taken care well.
> > I can see ISP is one such case. With this series I can see S2R breaks
> > [1] on 5250 chromebook with current mainline kernel (same applies for
> > arndale and smdk5250, but I have tested on these boards yet)
> 
> Thanks for catching that!  Let's make sure not to break suspend/resume.
> 
> Given that these power domains are actually used as the domains for
> some of the System MMU nodes I don't totally object to adding them in
> the same patch, but if they're breaking things then I agree that we
> could leave them out and add them in a later patch (once issues are
> sorted out).
> 

Thank you, Vikas.

Let me consider adding ISP power doamin after checking
power down sequence of ISP domain.

KyongHo
