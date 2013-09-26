Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab3IZFsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:48:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17625 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3IZFsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:48:14 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-18-5243ca9d15cc
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mateusz Krawczuk'" <m.krawczuk@partner.samsung.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com, t.figa@samsung.com, m.szyprowski@samsung.com,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1380043160-16824-1-git-send-email-m.krawczuk@partner.samsung.com>
 <02f401ceba7b$6dc16e20$49444a60$%kim@samsung.com>
In-reply-to: <02f401ceba7b$6dc16e20$49444a60$%kim@samsung.com>
Subject: RE: [RFC] clk: samsung:  Remove old clock drivers for s5pc100 and
 s5pv210
Date: Thu, 26 Sep 2013 14:48:12 +0900
Message-id: <02fb01ceba7b$fd0e9c60$f72bd520$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65Sj/VUdQa9U/sQhinydiFkQXLVABL2DDgAACOAGA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zI925p5yDDPrecFhsnLGe1eJs0xt2
	i02Pr7FaXN41h81ixvl9TBa3L/NanF5zitli7ZG77BbrZ7xmceD0aGnuYfPYvKTe4+C7PUwe
	fVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlbHm3DrGgj/cFdOOzGFpYDzE2cXIySEhYCIx/egx
	NghbTOLCvfVgtpDAMkaJI93KMDUbV5xi7GLkAoovYpT4OPk/G4Tzl1Gi/8Q2RpAqNgENicPv
	n7GD2CIC5hI3L20AK2IW+MMo8XhCNzvE2CZGicbVUiA2p4CdxKPnj8HiwgIhEptu32ABsVkE
	VCX+/V8NNpRXwFbi9dLPzBC2oMSPyffAapgFtCTW7zzOBGHLS2xe8xaohgPoVHWJR391IW6w
	kji/+TFUiYjEvhfvwD6QEPjKLvHh7zk2iF0CEt8mH2KB6JWV2HSAGeJjSYmDK26wTGCUmIVk
	8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MULieeIOxvsHrA8xJgOt
	n8gsJZqcD0wHeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9i
	ZOLglGpgrO36XDx/bVL6lP6V2T/z9TjZWwqLvmQ6bHz2UT3nA+uf7blq4QdC3oSyOl21+eih
	9U9JfN5n1s1imgkn/N/kXTjsY6jRUDxz/9cMPe3SqhUdeRfvWr+7u+SfjMjhng1z2l21pM5P
	CEgJLT/WEr3zS/9XjT/li3OLqpc3v792uVEsMzbN4Z+2EktxRqKhFnNRcSIAMPiFev0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd25p5yDDE5vZ7HYOGM9q8XZpjfs
	FpseX2O1uLxrDpvFjPP7mCxuX+a1OL3mFLPF2iN32S3Wz3jN4sDp0dLcw+axeUm9x8F3e5g8
	+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGmnPrGAv+
	cFdMOzKHpYHxEGcXIyeHhICJxMYVpxghbDGJC/fWs3UxcnEICSxilPg4+T+U85dRov/ENrAq
	NgENicPvn7GD2CIC5hI3L20AK2IW+MMo8XhCN1hCSKCJUaJxtRSIzSlgJ/Ho+WOwuLBAiMSm
	2zdYQGwWAVWJf/9Xgw3lFbCVeL30MzOELSjxY/I9sBpmAS2J9TuPM0HY8hKb17wFquEAOlVd
	4tFfXYgbrCTOb34MVSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84
	Mbe4NC9dLzk/dxMjOF08k9rBuLLB4hCjAAejEg/vBWbnICHWxLLiytxDjBIczEoivN+MgEK8
	KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xleSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQS
	SE8sSc1OTS1ILYLZwsTBKdXAGM1WoVM5f9vWvG8qkg8UFir2PJ4uyWIbky7idqZEzEZ8cwCT
	+M29m5ISQ3WbQyT57VjvPbty8Tyb/baApBDn9cv/HLh+Z1HZMn1tWWPb/xKTPe+bi1fNVdD9
	NPPgys/t9aF/3+/Y/0Kga87ysiuRjlLr+UTqwmxUv0mtZnB/JLBpvTCDuPNOJZbijERDLeai
	4kQAcEXOgFsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> Mateusz Krawczuk wrote:
> >
> > This patch removes old clock management code for S5PC100 and
> > S5PC110/S5PV210,
> > since the platform has been already moved to the new clock driver
> > using Common Clock Framework.
> >
> > Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > This patch series require
> > S5PC100 and S5PV210 patch series moving to common clock framework.
> >
> >  arch/arm/mach-s5pc100/Kconfig  |    2 +-
> >  arch/arm/mach-s5pc100/Makefile |    1 -
> >  arch/arm/mach-s5pc100/clock.c  | 1361
----------------------------------
> -
> > ----
> >  arch/arm/mach-s5pv210/Kconfig  |    2 +-
> >  arch/arm/mach-s5pv210/Makefile |    1 -
> >  arch/arm/mach-s5pv210/clock.c  | 1365
----------------------------------
> -
> > -----
> >  6 files changed, 2 insertions(+), 2730 deletions(-)
> >  delete mode 100644 arch/arm/mach-s5pc100/clock.c
> >  delete mode 100644 arch/arm/mach-s5pv210/clock.c
> >
> In this case, would be easier to review with using "-D" for format-patch.
> 
> And this should be followed by moving common clk series for
> s5pc100/s5pv210.
> See s3c64xx common clk patches in v3.13-next/common-clk-s3c64xx branch as
> a
> reference.
> 
> And I have never seen common clk stuff for s5pc100. In addition, I'm not

Oh, I found, there is series for common clk s5pc100 :)

> sure we _still_ need to support s5pc100 in mainline.
> 
Thanks,
Kukjin

