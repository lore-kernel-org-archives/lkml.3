Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaEIBJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:09:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53876 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbaEIBJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:09:39 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-f2-536c2ad116ba
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc: "'Nishanth Menon'" <nm@ti.com>,
        "'Linux PM list'" <linux-pm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Len Brown'" <len.brown@intel.com>,
        "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
 <CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
 <003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
 <CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
 <5367946F.1030407@ti.com>
 <CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
 <CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
 <CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
 <003e01cf6984$fb950280$f2bf0780$@samsung.com>
 <CAGo_u6o0J_T_hnmDAiYpsDxe77iKPCjuWisZJfTjYYOVGJF96A@mail.gmail.com>
 <CAKohpo=qbj9w5=wWHEG=9c2spjbbhaDaXG+F-Lhe9QffV9sDbw@mail.gmail.com>
 <001501cf6a5c$07bc2520$17346f60$@samsung.com>
 <CAGo_u6rAY1Cqh6_1RPsjGMwqNSVr=yW+VgyXfEjA6V+LT-SMcQ@mail.gmail.com>
 <000301cf6a62$413c16b0$c3b44410$@samsung.com>
 <CAKohponiuHYjLve5ywLSGtDPPFN9a54gzZUicn1m702B2Ct3Pw@mail.gmail.com>
In-reply-to: <CAKohponiuHYjLve5ywLSGtDPPFN9a54gzZUicn1m702B2Ct3Pw@mail.gmail.com>
Subject: RE: [PATCH 1/3] PM / OPP: Add support for descending order for cpufreq
 table
Date: Fri, 09 May 2014 10:09:37 +0900
Message-id: <000e01cf6b23$58fda900$0af8fb00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIqe0fjYa0YwQL6oKQ2dX7E8rarYwGe0UWzAg3L9n0CFbDXrQI73VqNAJ+GCpEBnU9akQFwpfDYAuYRDbQCG7oysAHyEw+TAdaKEeECfNgZegIzixHbAtOrQxmZoXkiMA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zQ92LWjnBBs8vm1s0XA2xmDVlL5PF
	5V1z2Cw+9x5htHjz4yyTxZnTl1gtNn71cGD3WLznJZPHnWt72Dy2XG1n8ejbsorR4/iN7Uwe
	nzfJBbBFcdmkpOZklqUW6dslcGUcn9XCXtAtVHGw8QprA+MD7i5GTg4JAROJj4/XsUHYYhIX
	7q0Hsrk4hASWMUpc/TGNGabo2eM7rBCJRYwSLXOeQDn/GCU6/55lAqliE9CVOLZ+CyuILSKg
	I9H/exkzSBGzwF9GieVNP1kgOqawS1ze8hDI4eDgFAiWaDngB9IgLBAusWbdTCaQMIuAqsSc
	5lKQMK+ApcSTW3fYIGxBiR+T77GA2MwC6hKT5i1ihrC1JZ68u8AKcamCxI6zrxlBVokITGGU
	eNyygB2iSERi34t3YAkJga/sEm8W9YAlWAQEJL5NPgR2j4SArMSmA1AvS0ocXHGDZQKjxCwk
	u2ch2T0Lye5ZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESyb07GG8fsD7EmAy0
	fiKzlGhyPjAR5JXEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDo0deaIbO8xDpL5v/tCsufHp6okeKpqPW9DbWAm0BjfT157gWav4xrqpew9A093HE
	rYb4+v/fi5UuTLG1Xf56foXF97t94qInbu7+XCH2pV9g/X1R5WeTSxZcP2mWvtAoT4PZa+fS
	E2tPnJyS8CvhR/20HWzPjHgDzTYIhd+6rFP+2z7qyy3llUosxRmJhlrMRcWJAOxcEwD6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd2LWjnBBp+nGVs0XA2xmDVlL5PF
	5V1z2Cw+9x5htHjz4yyTxZnTl1gtNn71cGD3WLznJZPHnWt72Dy2XG1n8ejbsorR4/iN7Uwe
	nzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOD6rhb2gW6jiYOMV
	1gbGB9xdjJwcEgImEs8e32GFsMUkLtxbz9bFyMUhJLCIUaJlzhNWCOcfo0Tn37NMIFVsAroS
	x9ZvAesQEdCR6P+9jBmkiFngL6PE8qafLBAdU9glLm95CORwcHAKBEu0HPADaRAWCJdYs24m
	E0iYRUBVYk5zKUiYV8BS4smtO2wQtqDEj8n3WEBsZgF1iUnzFjFD2NoST95dgLpUQWLH2deM
	IKtEBKYwSjxuWcAOUSQise/FO8YJjEKzkMyahWTWLCSzZiFpWcDIsopRNLUguaA4KT3XSK84
	Mbe4NC9dLzk/dxMjOE08k97BuKrB4hCjAAejEg/viynZwUKsiWXFlbmHGCU4mJVEeF8sAwrx
	piRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjCF5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QDY0gRt7TGA615lWcXrBd8ZupnOvfZQeOK+iYWFaVyoztxk7V3
	ZitN+cceMuH4p5bWt7krD5S4vpvwKsvP7IZWqvXB1lOBTAse8r4v3MOtLCsrzt/SfNDw/lom
	lgXGDmIb13J3VAr7HlsgOVFu08q/2gtDSgpl3p//1e8xsSQufNpJJu3I51t9lViKMxINtZiL
	ihMBHArEsVcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 May 2014 2:56 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> 
> Not necessarily. People may need a multiplier as well or some other
> configuration and so this stuff was left for drivers to implement.

-> In exynos cpufreq driver, if we want to support more frequency, then 
we have to describe frequency information in dts file and have to change exynos cpufreq
 driver file also(For adding divider value). 
But if dev_pm_opp has a divider value for DVFS,when we want to support more frequency 
we have only to change the dts file.

I think that it is easy to maintain cpufreq driver and very convenient.
(Can be applied to devfreq)

This is a example (exynos4210 doesn't support DT.)

--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -64,6 +64,7 @@ struct dev_pm_opp {
        bool available;
        unsigned long rate;
        unsigned long u_volt;
+       unsigned int ctl[2];

        struct device_opp *dev_opp;
        struct rcu_head head;
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index cacf614..007a411 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -81,6 +81,24 @@
                interrupts = <2 2>, <3 2>;
        };

+       cpufreq@160000 {
+               compatible = "samsung,exynos7842-cpufreq";
+               reg = <0x160000 0x1000>;
+               interrupts = <0 57 0>;
+               operating-points = <
+                               /* KHz    uV    clkdiv0 clkdiv1 */
+                               1500000 1100000 0x11111 0x11111
+                               1400000 1075000 0x22223 0x22222
+                               1300000 1050000 0x33333 0x33333
+                               1200000 1025000 0x44444 0x44444
+                               1100000 1000000 0x55555 0x55555
+                               1000000 975000  0x66666 0x66666
+                               900000  950000  0x77777 0x77777
+                               800000  925000  0x88888 0x88888
+               >;
+       };
+
+
        pinctrl_0: pinctrl@11400000 {
                compatible = "samsung,exynos4210-pinctrl";
                reg = <0x11400000 0x1000>;


Thanks

Best Regards.

