Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaKHKRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 05:17:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32014 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaKHKQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 05:16:57 -0500
X-AuditID: cbfee68d-f79296d000004278-1d-545ded967a12
From: Kukjin Kim <kgene@kernel.org>
To: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'BartlomiejZolnierkiewicz'" <b.zolnierkie@samsung.com>
References: <1415360662-30390-1-git-send-email-k.kozlowski@samsung.com>
 <545CB220.9030007@samsung.com> <1415361564.31102.2.camel@AMDC1943>
In-reply-to: <1415361564.31102.2.camel@AMDC1943>
Subject: RE: [PATCH] ARM: dts: Fix booting on Rinato market device
Date: Sat, 08 Nov 2014 19:16:54 +0900
Message-id: <004701cffb3d$1edef9e0$5c9ceda0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFseshRFCu65dPQTNbGeTE91r9GzgInje8CAdInaKac/bar0A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Zvu60t7EhBtOmmFtsnLGe1WLSugNM
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktHj9wtDibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9
	fpHJYsL0tSwWrXuPsDvwe6yZt4bRo6W5h83jcl8vk8ffVS+YPVYu/8LmsWlVJ5vH5iX1Hn1b
	VjF6fN4kF8AZxWWTkpqTWZZapG+XwJVxp7WdpeCYcMWzS94NjGf4uxg5OSQETCRePH/ADGGL
	SVy4t56ti5GLQ0hgGaPE8i0NzDBFOxsWQCWmM0q86LzHAuH8ZZS49/IykMPBwSagLNHYpA/S
	ICygJbFwSxNYWEQgVmLCCxuQcmaBNhaJs58boQb1MEpc2NDDAtLAKWAgsaZhBztEs5PE3Rtr
	wTazCKhKvH4xFayGV8BCYur066wQtqDEj8n3wOLMAuoSk+YtYoawtSWevLvACnG1gsSOs68Z
	QWwRoJnzZuyCqhGR2PfiHSNEzREOib6uZIhdAhLfJh8CO1pCQFZi0wGo5yUlDq64wTKBUXIW
	ks2zkGyehWTzLCQbFjCyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQISSO9OxhvH7A+xCjA
	wajEw3ujJTZEiDWxrLgy9xCjKdBFE5mlRJPzgckqryTe0NjMyMLUxNTYyNzSTEmcV1HqZ7CQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGRtEJef0mEwOy1K9ULjy25On1ry8kHtj7fNpd+TP5
	Y+u9zfNmXtL//ejD0urTbxivpPWrusWevshvuDhx6bT5CW+c3xY5N/1Z/TfmGMuTpc87696z
	MT8yXy977vgH04f8utumb+t75l897//G47s/Jm2J/NW8qTL568W52x2633KHC4gvXWT84shr
	JZbijERDLeai4kQAB+ZCUR4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQd1pb2NDDH4dMLTYOGM9q8WkdQeY
	LK5/ec5qMf/IOVaL/jcLWS3OvVrJaPH6haHF2aY37BabHl9jtbi8aw6bxYzz+5gsbl/mtVh6
	/SKTxYTpa1ksWvceYXfg91gzbw2jR0tzD5vH5b5eJo+/q14we6xc/oXNY9OqTjaPzUvqPfq2
	rGL0+LxJLoAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUn
	QNctMwfoASWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxp3WdpaCY8IV
	zy55NzCe4e9i5OSQEDCR2NmwgA3CFpO4cG89kM3FISQwnVHiRec9FgjnL6PEvZeXgRwODjYB
	ZYnGJn2QBmEBLYmFW5rAwiICsRITXtiAlDMLtLFInP3cCDWoh1HiwoYeFpAGTgEDiTUNO9gh
	mp0k7t5YywxiswioSrx+MRWshlfAQmLq9OusELagxI/J98DizALqEpPmLWKGsLUlnry7wApx
	tYLEjrOvGUFsEaCZ82bsgqoRkdj34h3jBEbhWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJEZymnknvYFzVYHGIUYCDUYmH90ZLbIgQa2JZcWXuIUYJDmYlEd7e
	80Ah3pTEyqrUovz4otKc1OJDjKZAn05klhJNzgem0LySeENjEzMjSyMzCyMTc3Mlcd6DrdaB
	QgLpiSWp2ampBalFMH1MHJxSDYzbvpy4vM7nRrESX+XD1Z4MFz8ePDLFxDRrnc+TcqPHXyIW
	/3kiffA2f/e3HimZ56lvORhWytV8f+V+Kcn+tbDw1SJVfZG5HybahquJXdvuvn1zdrr0VoNN
	MqlS+RPPm2kvCTTWmain3TORY+e3qLvb76X+YdkS8Mc5xVQ1v0xislyH1xoTdT0lluKMREMt
	5qLiRABIqPThaQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Kozlowski wrote:
> 
> On pią, 2014-11-07 at 20:50 +0900, Chanwoo Choi wrote:
> > Hi Krzysztof,
> >
> > On 11/07/2014 08:44 PM, Krzysztof Kozlowski wrote:
> > > The bootloader on market Rinato (Gear 2) device checks for revision in
> > > compatible field of DTB. If it is not present or lower than required
> > > then booting fails with: "Could not do normal boot. (no DTB found)".
> > >
> > > Log of bootloader in case of failure:
> > > h/w: revision  = 0x06
> > > h/w: schematic = SM-R380_Rev0.5_Final_0205
> > > date = 2000/01/01 12:00:21 (UTC)
> > > cmu_div:4, div:5, src_clk:800000000, pixel_clk:31860720
> > > load_kernel: loading boot image from 57344.. (BOOT)
> > > load_kernel: found zImage, size: 0x3267e8
> > > 0xbc Error!
> > > Verify_Binary_Signature: failed.
> > > pit_check_signature (BOOT) invalid.
> > > load_kernel: found custom kernel (ret:-2147483647)
> > >  No need to update kernel type.
> > > Detected board: samsung,rinato-rev06
> > > Could not do normal boot. (no DTB found)
> > > : Entering usb mode for SM-R380_EUR_XX (65535)..
> > >
> > > Add a "rev06" suffix to compatible to satisfy the bootloader.
> > >
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > ---
> > >  arch/arm/boot/dts/exynos3250-rinato.dts | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
> > > index 84380fa13e37..f72ba0a1d915 100644
> > > --- a/arch/arm/boot/dts/exynos3250-rinato.dts
> > > +++ b/arch/arm/boot/dts/exynos3250-rinato.dts
> > > @@ -18,7 +18,8 @@
> > >
> > >  / {
> > >  	model = "Samsung Rinato board";
> > > -	compatible = "samsung,rinato", "samsung,exynos3250", "samsung,exynos3";
> > > +	compatible = "samsung,rinato", "samsung,rinato-rev06",
> > > +			"samsung,exynos3250", "samsung,exynos3";
> >
> > I think it is wrong. The released bootloader from Samsung is not u-boot.
> > Instead, you have to update u-boot to support Exynos3250-basd Rinato board.
> 
> The bootloader on device also was not a u-boot. So the fix is for native
> bootloader delivered on device.
> 
> I do not insist that this is proper fix. It was just needed to boot the
> device with custom kernel.
> 
> Anyway, thanks for comments!
> 
Hi Krzysztof and Chanwoo,

So, we don’t need this to fix the problem Krzysztof said? OK.

- Kukjin

