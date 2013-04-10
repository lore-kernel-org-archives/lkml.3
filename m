Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3DJKPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:15:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48026 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3DJKPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:15:51 -0400
X-AuditID: cbfee690-b7f656d0000007e3-52-51653bd5eb4c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "=?utf-8?Q?'Heiko_St=C3=BCbner'?=" <heiko@sntech.de>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201302180103.53084.heiko@sntech.de>
In-reply-to: <201302180103.53084.heiko@sntech.de>
Subject: RE: [PATCH v2 0/3] ARM: S3C24XX: Add devicetree support for s3c2416
Date: Wed, 10 Apr 2013 19:15:48 +0900
Message-id: <30ff01ce35d4$5f4920d0$1ddb6270$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Na3cIBs6ksCE0RZ2rWo4XC6jkogoaFgaA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zfd2r1qmBBtu+ilkcmP2Q1eLVmY1s
	Fv8fvWa12PT4GqvF5V1z2CxmnN/HZHF4xQEmi2MzljA6cHgs+HyF3ePOtT1sHpuX1Hucn7GQ
	0ePnSx2P7dfmMXt83iQXwB7FZZOSmpNZllqkb5fAlXHlyRrmgu8SFV+2PmBtYGwS7mLk5JAQ
	MJF41HucBcIWk7hwbz1bFyMXh5DAMkaJwxs3MHcxcoAVPVtgARGfzigx5f4JdpAGIYG/jBK3
	/wiB2GwCGhKH3z9jBykSEdjPKPH6fAsriMMsMIFRYsX6PrBJQgIGEjN2+YI0cAoYSky9dg1s
	s7CAj8Tun98YQWwWAVWJo2+/gC3gFbCV6P9ygQ3CFpT4MfkeC8gYZgF1iSlTckHCzALaEk/e
	XWCFuFNd4tFfXZCwiICRxN3lTawQJSIS+168YwS5RkKgl0Pi39wL7BCrBCS+TT7EAtErK7Hp
	ADMkHCQlDq64wQJ09ywki2chLJ6FZPEsJBsWMLKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/d
	xAiJ6Qk7GO8dsD7EmAy0fSKzlGhyPjAl5JXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBUdBRzL9yapiCROCU1OzDt2MWcLTp9F7aOVX0iHvgq76Q
	xdedBHSzTRYFmVaeWrns3Ka3za6NanM1a9g+3/zA4cW+RtH0nXlQZvEqza2G0qbt++UjLr30
	FLv6LXgZw4H+p5q7LJYJzfjupPMjJLbouX2nZuOi5e8OfTp62PzZ5N3vv7xKED03U4mlOCPR
	UIu5qDgRAC13/lX/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jQd2r1qmBBofeCFocmP2Q1eLVmY1s
	Fv8fvWa12PT4GqvF5V1z2CxmnN/HZHF4xQEmi2MzljA6cHgs+HyF3ePOtT1sHpuX1Hucn7GQ
	0ePnSx2P7dfmMXt83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQ
	l5ibaqvk4hOg65aZA3SUkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj
	ypM1zAXfJSq+bH3A2sDYJNzFyMEhIWAi8WyBRRcjJ5ApJnHh3nq2LkYuDiGB6YwSU+6fYAdJ
	CAn8ZZS4/UcIxGYT0JA4/P4ZO0iRiMB+RonX51tYQRxmgQmMEivW9zGDTBUSMJCYscsXpIFT
	wFBi6rVrLCC2sICPxO6f3xhBbBYBVYmjb7+ALeAVsJXo/3KBDcIWlPgx+R4LyBhmAXWJKVNy
	QcLMAtoST95dYIW4WV3i0V9dkLCIgJHE3eVNrBAlIhL7XrxjnMAoNAvJoFkIg2YhGTQLSccC
	RpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEJ45nUDsaVDRaHGAU4GJV4eD30UwKFWBPL
	iitzDzFKcDArifBaaKUGCvGmJFZWpRblxxeV5qQWH2JMBnpzIrOUaHI+MJnllcQbGpuYGVka
	mVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOjyp06hjkHhE8IWfy2F7v26uOp
	klNOU/8d5TCxO/lrZnxm2eNVbsoGx5IWXW2blR0dOU3M610Rp9698OVpjKsWP1/060nvY8n/
	p6e82sK+w2lbizKzu5yjct8j5l4x0WtxFzqWLlofK98mxBbw6FBOmtetlMazbr+yzE4XHeXc
	sCa+3otzzm4OJZbijERDLeai4kQAMQu5YlwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Stübner wrote:
> 
> This is the second installment of beginning devicetree support the
> Samsung S3C24xx architectures and focuses on the s3c2416 for now.
> 
> Included is the devicetree support for the s3c24xx irq controller and
> basic support for smdk2416 boards, which can sucessfully boot.
> 
> 
> After the discussion with Thomas Abraham on v1 and staring to long at all
> of
> this, I'm not even sure if having the interrupt mapping in the binding
> is the correct way to go anymore.
> 
> The key positive aspect of this solution is, that after everything is
> running
> via dt all the SoC specific mapping tables in the driver can go away,
> cutting
> its length in half.
> 
> The other option would be as Thomas suggested to define specific irq-
> controller
> types (i.e. s3c2416-intc, s3c2443-intc, ... resulting in 16 types) and
> keep
> the mapping data in the code, as it is now.
> 
> So I would be very thankful for a bit of guidance on what is the better
> way.
> 
> 
> The series depends on the finalized s3c24xx irq rework, which probably
> won't
> make it into 3.9 and also the clocksource dt support by Tomasz Figa, which
> are not in any tree yet.
> 
> 
> Changes since v1:
> - adapt to changes in the underlying s3c24xx irq rework
>   = more shared init code
> - use irqchip infrastructure
> - limit number of possible irq-types to not encode implementation details
>   into the binding
> - include new samsung-clocksource
> 
> Heiko Stuebner (3):
>   ARM: S3C24XX: move irq driver to drivers/irqchip
>   irqchip: irq-s3c24xx: add devicetree support
>   ARM: S3C24XX: Add devicetree support and dt-board file for s3c2416 SoCs
> 
>  .../interrupt-controller/samsung,s3c24xx-irq.txt   |   53 ++++++
>  arch/arm/boot/dts/Makefile                         |    1 +
>  arch/arm/boot/dts/s3c2416-smdk2416.dts             |   79 ++++++++
>  arch/arm/boot/dts/s3c2416.dtsi                     |  193 ++++++++++++++++++++
>  arch/arm/boot/dts/s3c24xx.dtsi                     |  165 +++++++++++++++++
>  arch/arm/mach-s3c24xx/Kconfig                      |   10 +
>  arch/arm/mach-s3c24xx/Makefile                     |    3 +-
>  arch/arm/mach-s3c24xx/mach-s3c2416-dt.c            |   91 +++++++++
>  drivers/irqchip/Makefile                           |    1 +
>  .../irq.c => drivers/irqchip/irq-s3c24xx.c         |  128 +++++++++++++
>  10 files changed, 723 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-
> controller/samsung,s3c24xx-irq.txt
>  create mode 100644 arch/arm/boot/dts/s3c2416-smdk2416.dts
>  create mode 100644 arch/arm/boot/dts/s3c2416.dtsi
>  create mode 100644 arch/arm/boot/dts/s3c24xx.dtsi
>  create mode 100644 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c
>  rename arch/arm/mach-s3c24xx/irq.c => drivers/irqchip/irq-s3c24xx.c (92%)
> 
> --
> 1.7.2.3

Basically, looks good to me and thanks for your effort.

BTW, if you don't mind, would be better to send to upstream next time. Because I need to consider other s3c24xx SoCs for DT...

Thanks.

- Kukjin

