Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965660AbaDJKhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:37:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19798 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934795AbaDJKhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:37:13 -0400
X-AuditID: cbfee68f-b7f156d00000276c-15-53467457ef7f
From: Chanho Park <chanho61.park@samsung.com>
To: "'Marc Zyngier'" <marc.zyngier@arm.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: mark.rutland@arm.com, linux-samsung-soc@vger.kernel.org,
        t.figa@samsung.com, hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
 <1397122124-15690-8-git-send-email-cw00.choi@samsung.com>
 <878urd33g4.fsf@approximate.cambridge.arm.com>
In-reply-to: <878urd33g4.fsf@approximate.cambridge.arm.com>
Subject: RE: [PATCH 07/27] irqchip: Declare cortex-a7's irqchip to initialize
 gic from dt
Date: Thu, 10 Apr 2014 19:37:12 +0900
Message-id: <002e01cf54a8$d59897e0$80c9c7a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHswY/dwiExWmV8C5CYXcVGb5tK2AINjaeNAnkl/FKaq5gCUA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42JZI2JSpBte4hZs0P1Hy+L6l+esFp8/tLBb
	TLo/gcWid8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLp9YtMFjMmv2SzWD/jNYvF
	5k1TmS327pzM6MDnsWbeGkaPd+fOsXtsXlLv0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBkX
	57AU7BWsmDjvEVMD4wu+LkZODgkBE4n566+xQdhiEhfurQeyuTiEBJYySvze94sJpmhR01Gw
	IiGB6YwST/6wQhT9Y5R4NO8bI0iCTUBXYsvzV2C2iECwxKLPD1hAipgFLjFJXOjdyg7RsYlR
	YnnzdaCxHBycAtYSR/s9QBqEBaIl/nw9zwJiswioShy8eZQZxOYVsJSY/38uG4QtKPFj8j2w
	GmYBLYn1O48zQdjyEpvXvGWGuFRBYsfZ11BHOEk0zO5mh6gRkdj34h0jyA0SAnM5JM5d2c4E
	sUxA4tvkQywg90gIyEpsOgA1R1Li4IobLBMYJWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk
	9CJjveLE3OLSvHS95PzcTYzAFHD637P+HYx3D1gfYkwGWj+RWUo0OR+YQvJK4g2NzYwsTE1M
	jY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Peft3ne3x+KR7rVPv6
	+SjjT26bFdpWZQydC06z7whaocds6i+wYUW1/rNLna9evZ3Vyv7n7YY9qaFJjUxah8I17tRW
	1ylb3Dj7r6Rkp09JrtI2z5X7mZdvf3Fx39HkqyW7L1mt9ffyPP7/hPDkA8djU2pMinb+S9Ba
	P8GSN316uuXrHAPGk6FKLMUZiYZazEXFiQBWxsaOFwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQd3wErdgg/knFC2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF3zv/2CyWXr/IZDFj8ks2i/UzXrNY
	bN40ldli787JjA58HmvmrWH0eHfuHLvH5iX1Hn1bVjF6fN4kF8Aa1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYx4+IcloK9ghUT5z1iamB8wdfFyMkhIWAisajpKBuELSZx
	4d56MFtIYDqjxJM/rF2MXED2P0aJR/O+MYIk2AR0JbY8fwVmiwgESyz6/IAFpIhZ4BKTxIXe
	rewQHZsYJZY3X2fqYuTg4BSwljja7wHSICwQLfHn63kWEJtFQFXi4M2jzCA2r4ClxPz/c9kg
	bEGJH5PvgdUwC2hJrN95nAnClpfYvOYtM8SlChI7zr6GOsJJomF2NztEjYjEvhfvGCcwCs1C
	MmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgBPNMagfjygaLQ4wC
	HIxKPLwHlrkGC7EmlhVX5h5ilOBgVhLh3Z3pFizEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ
	+cDkl1cSb2hsYmZkaWRuaGFkbE6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjNu7Qzhj
	ZRgEK+rPRCSnPLgcUtavdvqub4vuSh3nF753g7w+/wgzlmx8ZzZrt94rhUX2+xwOKOkwPzbM
	fHxRNux78rc3Zq8CimU6OFu/lFubrvITLpofw1r69zFnmsub8Kjo5d0uApIPjO3Ld26vO7R+
	5bYSIe0ZnPe0++5G9cvYbUu28yhUYinOSDTUYi4qTgQAfzvt1HQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: linux-arm-kernel [mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Marc Zyngier
> Sent: Thursday, April 10, 2014 7:05 PM
> To: Chanwoo Choi
> Cc: mark.rutland@arm.com; linux-samsung-soc@vger.kernel.org;
> t.figa@samsung.com; hyunhee.kim@samsung.com; sw0312.kim@samsung.com;
> linux-kernel@vger.kernel.org; yj44.cho@samsung.com; inki.dae@samsung.com;
> kyungmin.park@samsung.com; kgene.kim@samsung.com; Thomas Gleixner;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 07/27] irqchip: Declare cortex-a7's irqchip to
> initialize gic from dt
> 
> On Thu, Apr 10 2014 at 10:28:24 am BST, Chanwoo Choi
> <cw00.choi@samsung.com> wrote:
> > This patch declare coretex-a7's irqchip to initialze gic from dt
> > with "arm,cortex-a7-gic" data.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/irqchip/irq-gic.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> > index 4300b66..8e906e4 100644
> > --- a/drivers/irqchip/irq-gic.c
> > +++ b/drivers/irqchip/irq-gic.c
> > @@ -1069,6 +1069,7 @@ gic_of_init(struct device_node *node, struct
> device_node *parent)
> >  }
> >  IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
> >  IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
> > +IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
> >  IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
> >  IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
> 
> Frankly, this patch adds no value. Are we going to add
> "arm,cortex-a12-gic", "arm,cortex-a17-gic", "arm,cortex-a53-gic",
> "arm,cortex-a57-gic"? And that's just to mention the ARM Ltd cores...
> 
> Instead, how about defining a generic "arm,gic" property, and mandate
> that new DT files are using that? We can always use a more precise
> compatible for quirks.

I prefer it would be arm,gicv2 instead arm-gic.
In case of GICv3 of arm64, it can be arm,gicv3.

Best Regards,
Chanho Park

