Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaE1Et4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:49:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23435 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaE1Etx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:49:53 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-11-53856aee43a4
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mike Turquette'" <mturquette@linaro.org>,
        "'Tarek Dakhran'" <t.dakhran@samsung.com>,
        linux-kernel@vger.kernel.org
Cc: "'Rob Herring'" <robh+dt@kernel.org>, "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Rob Landley'" <rob@landley.net>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Vyacheslav Tyrtov'" <v.tyrtov@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Heiko Stuebner'" <heiko@sntech.de>,
        "'Romain Naour'" <romain.naour@openwide.fr>,
        "'Chander Kashyap'" <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Tarek Dakhran'" <t.dakhran@gmail.com>,
        "'Tarek Dakhran'" <t.dakhran@samsung.com>,
        "'Jonghwan Choi'" <jhbird.choi@samsung.com>
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
 <1401074613-29227-3-git-send-email-t.dakhran@samsung.com>
 <20140528004116.7816.69646@quantum>
In-reply-to: <20140528004116.7816.69646@quantum>
Subject: RE: [PATCH v11 2/3] clk: exynos5410: register clocks using common
 clock framework
Date: Wed, 28 May 2014 13:49:49 +0900
Message-id: <01a201cf7a30$41ecca90$c5c65fb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFLA9759H0kHQ27SjqSEX8Gj5vNBQJBHm7eAR7viIycQ1ckEA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTYRjHeXfOzi6inbzkm2TJoDua1/kuo8QPcehDRFFSBjrXQa2pY9PI
	T5m2vG26FFNHWcrKnLrJNDQpWUsTinnJmoopmnndWpAiXrDSHT/4tW+/933+D7+Hh4eLeU6w
	/bgpaRm0PE0sFRB8/NOfmZBA503lpeAhDUSlBjMLTRpHcPS0q5eNShw1bPT3u52NehfqAdLl
	uiFrjoODTFM2Nqp5oMPRYMdjAlX2dbLQ6KA7ej40wELTmgECaSqacGSYr8CR8m0XB7Wu5gO0
	rvqNIePsR4CMlXYcfajUAVReucKJhlRjdSOg7ueqCGqwWM2iNvRzGPVaO8ah6uuWCMqkLyCo
	hYYqNvXN9oagWnR3qQUbThW36gHVZqvGqEXT/gse1/inbtDSlNu0/MTpBH6yyRwrW/a6sz44
	i2cD565CwOVCMhwqDbxCwNvEPbB/3EgUAj7Xk3wBYHNBEZsphMOcJ/e2C7UALmrWcOaxAeDU
	RDVrK0WQR+D7XzOcLfYmM+FGx2dXCCMXCViT37PdUQfgT8cjVwePDIZNagexxV7kddjZv+Tq
	xsmDcHzW7HK7kyLYVm4iGN4NV8rG8S3GyMOwtLoWY/g4/OHs3541ALZb7YCZIgYOqBoAk/GG
	nXNOwGTqeNBansW4SLhcZsGZXfhDkxljInvhu5fDuAZA7Q6zdodZu8Os3WF4BnA98KFlEpki
	MUkeEqQQpyoy05KCJOmpJsBcl7odjJqjLECyqX+I+flI0jevLy0jPiRMGIoiwiPCQiNFwv/7
	Fvi6J04mXvQkk8QZ9C2altHyeHmmlFZYAIvL88sGpAjPHVF2yKTCvPDuBkGWKOZkn2PGe2Xc
	7avBIy+S72xhx+kkEz0VzcOqfbaZV/rz/JK4iGzRcOyhucv20auRE0UOq/3MnKEpoVU5NeIr
	VU9fyas6i86tcU3TX3rm18Qt0cZAgU2fGCc52r1qifIfO6Dk8p1ewoAmu5ifLsAVyeKQY5hc
	If4Hnf474nMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsVy+t9jAd13Wa3BBv/fC1hMWneAyeLh+pss
	FvOPnGO16H+zkNXi/6PXrBbnXq1ktFjSzG1xtukNu8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCxu
	X+a1WHr9IpPF0wkX2SwmTF/LYrHu5XQWi9a9R9gttvzsYLT43fOJ2WL981OMFutnvGaxODZj
	CaPF1Bk/2B0kPNbMW8Po0dLcw+Zxua+XyePvqhfMHjtn3WX3WLn8C5vHplWdbB6vVs9k9bhz
	bQ+bx+Yl9R6vrrF49G1Zxeix/do8Zo/Pm+QC+KIaGG0yUhNTUosUUvOS81My89JtlbyD453j
	Tc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgKGgpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zYdCC84Jtwxe/Lz1kaGN/xdzFyckgImEg0zW1kg7DFJC7cWw9kc3EICSxi
	lPg84RcLhPOXUeLxg3lMIFVsAhoSh98/YwexRQRKJf7uugRWxCzwmU1iYcdxqI7ljBJv30wD
	6+AUMJBY2/sGbIewQIzEvgtfwLpZBFQl7j0/wApi8wpYSmyfuokNwhaU+DH5HguIzSygLjFp
	3iJmCFtb4sm7C6wQtypI7Dj7mhHiCieJiz2rGSFqRCT2vXjHOIFRaBaSUbOQjJqFZNQsJC0L
	GFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQnx2fSOxhXNVgcYhTgYFTi4T2wuCVYiDWx
	rLgy9xCjBAezkgjvn4DWYCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OBybuvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgLGna94mPUyk55VhQ9vSU+n2y
	E6aevjpzrZByMfvJyOZT956pHCpf8eCmY8yx2va8h8ovw3rfVD+I/bgyNIIlnjGH87BfwNJ7
	n1VnT0uL//DDNcvekF0y59H0vKY04+A3nYv7Qj7daZ33bOPHbS6nf/5/rHLN9qnn2jPeu58u
	+nj7QNKj33NbFyqxFGckGmoxFxUnAgDjC9E70gMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Turquette wrote:
> 
> Quoting Tarek Dakhran (2014-05-25 20:23:32)
> > The EXYNOS5410 clocks are statically listed and registered
> > using the Samsung specific common clock helper functions.
> >
> > Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> > Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> > ---
> >  .../devicetree/bindings/clock/exynos5410-clock.txt |   45 +++++
> >  drivers/clk/samsung/Makefile                       |    1 +
> >  drivers/clk/samsung/clk-exynos5410.c               |  209
> ++++++++++++++++++++
> >  include/dt-bindings/clock/exynos5410.h             |   33 ++++
> >  4 files changed, 288 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-
> clock.txt
> >  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
> >  create mode 100644 include/dt-bindings/clock/exynos5410.h
> >
> > diff --git a/Documentation/devicetree/bindings/clock/exynos5410-
> clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
> > new file mode 100644
> > index 0000000..aeab635
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
> > @@ -0,0 +1,45 @@
> > +* Samsung Exynos5410 Clock Controller
> > +
> > +The Exynos5410 clock controller generates and supplies clock to various
> > +controllers within the Exynos5410 SoC.
> > +
> > +Required Properties:
> > +
> > +- compatible: should be "samsung,exynos5410-clock"
> > +
> > +- reg: physical base address of the controller and length of memory
> mapped
> > +  region.
> > +
> > +- #clock-cells: should be 1.
> > +
> > +All available clocks are defined as preprocessor macros in
> > +dt-bindings/clock/exynos5410.h header and can be used in device
> > +tree sources.
> > +
> > +External clock:
> > +
> > +There is clock that is generated outside the SoC. It
> > +is expected that it is defined using standard clock bindings
> > +with following clock-output-name:
> > +
> > + - "fin_pll" - PLL input clock from XXTI
> 
> Does fin_pll feed into the exynos5410-clock controller? If so, should
> the example clock-controller node below have a clocks and clock-names
> property?
> 
Well, it is fixed clocks and generated outside of the SoC...so maybe the properties are not required?

BTW, I've applied this series with Tomasz Figa's reviewed tag and sent out to arm-soc today so if any concerns on this, please let me know immediately.

> Otherwise patch looks good.
> 

Thanks,
Kukjin

