Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab3E0KMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:12:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53894 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab3E0KMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:12:13 -0400
X-AuditID: cbfee68f-b7f436d000000f81-cb-51a3317cebca
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Chen Gang'" <gang.chen@asianux.com>, ben-linux@fluff.org
Cc: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Linux-Arch'" <linux-arch@vger.kernel.org>
References: <5199E4AF.7040607@asianux.com> <51A32FD4.4000001@asianux.com>
In-reply-to: <51A32FD4.4000001@asianux.com>
Subject: RE: [PATCH] ARM: S5PV210: dependency issue,
 S5P_SLEEP is depend on ARM_CPU_SUSPEND
Date: Mon, 27 May 2013 19:12:11 +0900
Message-id: <158201ce5ac2$a7843de0$f68cb9a0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5awcki1hHLdrTcR4OlP4CeWwDg+QAAGItg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zQ90aw8WBBntfsllMWneAyeLVHRWL
	jl1fWSw2Pb7GanF51xw2ixnn9zFZ3L7M68Du0dLcw+ax598cVo+/q14we2xeUu/xeZNcAGsU
	l01Kak5mWWqRvl0CV8aiJ9eYCy5wVEx89ouxgfEJWxcjJ4eEgInE0TdLGCFsMYkL99YDxbk4
	hASWMUo8/jCTFabow5k37BCJRYwSU9ZPYIZw/jJKfO27BNbOJqAhcfj9M3YQW0TARqKl/ypY
	B7PAWUaJqw9vM4MkhAQ8JZ61PATbzSmgLXF64nsmEFtYIFbi+oEusHUsAqoSh2ccB4vzCthK
	rP3XzAhhC0r8mHyPBcRmFtCSWL8TooZZQF5i85q3QPM5gE5Vl3j0VxfiBiOJ3k0LGCFKRCT2
	vXjHCHKPhMBLdok1LeeZIHYJSHybfIgFoldWYtMBZoiPJSUOrrjBMoFRYhaSzbOQbJ6FZPMs
	JCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ3f4djHcPWB9iTAZaP5FZSjQ5Hxj7
	eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgLL5V
	r3u6wFV76vvA57POJzRPvier+jZ8d7Rz2IZcwVcbO1ffnj7NbPav+0x7TxVlx/LNfuNyUSt/
	//qOG/Oni0Uc/nvFhuUsW6X9j9+ciqbec2c67CncLHixYvftrxatt9Oz+Dmak89vvnW7PGC5
	eltg24M9mR7B7w3s+x+ye9wJtVTj0ny9TImlOCPRUIu5qDgRAFN/kknzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd0aw8WBBhsPMFlMWgckXt1RsejY
	9ZXFYtPja6wWl3fNYbOYcX4fk8Xty7wO7B4tzT1sHnv+zWH1+LvqBbPH5iX1Hp83yQWwRjUw
	2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaGkUJaY
	UwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzFj05BpzwQWOionPfjE2MD5h62Lk
	5JAQMJH4cOYNO4QtJnHh3nqgOBeHkMAiRokp6ycwQzh/GSW+9l1iBKliE9CQOPz+GViHiICN
	REv/VXaQImaBs4wSVx/eZgZJCAl4SjxreQi2glNAW+L0xPdMILawQKzE9QNdrCA2i4CqxOEZ
	x8HivAK2Emv/NTNC2IISPybfYwGxmQW0JNbvhKhhFpCX2LzmLdB8DqBT1SUe/dWFuMFIonfT
	AkaIEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjBieGZ1A7GlQ0WhxgFOBiVeHh/zFoUKMSaWFZcmXuIUYKDWUmENyEaKMSbklhZlVqUH19U
	mpNafIgxGejRicxSosn5wKSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2Mey5te69yt9WEM/t389yy5JcNUtMd2g59l7+/bqq7BPvPhXq9Wi+/SEo1C88+
	na4/P67smsJpY5d0S5emOwsmvK13yNzeKazDGrEglnu3Tf9F7pwCk85HZ18ECxtd27KleIHp
	X+cze3xU5+1frFzgv23uWv6c1z9Wma/sEV3t2r/ZKriBga1YiaU4I9FQi7moOBEARsDYwFAD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang wrote:
> 
> Hello Maintainers:
> 
Hi,

> Please help check this patch whether OK, when you have time.
> 
> 
> Thanks.
> 
> On 05/20/2013 04:54 PM, Chen Gang wrote:
> >
> > When randconfig with MMU for arm s5pv210 (and select all cpu type),
> > need let S5P_SLEEP depend on ARM_CPU_SUSPEND, or will cause issue below:
> >
> >   arch/arm/plat-samsung/built-in.o: In function `s3c_cpu_resume':
> >   arch/arm/plat-samsung/s5p-sleep.S:83: undefined reference to
> `cpu_resume'
> >
> >
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  arch/arm/plat-samsung/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-
> samsung/Kconfig
> > index f8ed2de..1d38541 100644
> > --- a/arch/arm/plat-samsung/Kconfig
> > +++ b/arch/arm/plat-samsung/Kconfig
> > @@ -483,6 +483,7 @@ config S5P_PM
> >
> >  config S5P_SLEEP
> >  	bool
> > +	select ARM_CPU_SUSPEND

Probably,

+	select ARM_CPU_SUSPEND if PM ?

selecting the S5P_SLEEP depends on PM though...

- Kukjin

