Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaCNLtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:49:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24048 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaCNLtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:49:21 -0400
X-AuditID: cbfee68e-b7f566d000002344-80-5322ecbf4d25
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux DeviceTree'" <devicetree@vger.kernel.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Varun Sethi'" <Varun.Sethi@freescale.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>
References: <20140314140129.68a41cc1bd9e0a48a198ca13@samsung.com>
 <CAK9yfHzRasE3jroDUZgAa=DN5N=2ZDAxgNiHDCip+f2868BAVQ@mail.gmail.com>
In-reply-to: <CAK9yfHzRasE3jroDUZgAa=DN5N=2ZDAxgNiHDCip+f2868BAVQ@mail.gmail.com>
Subject: RE: [PATCH v11 01/27] iommu/exynos: do not include removed header
Date: Fri, 14 Mar 2014 20:49:18 +0900
Message-id: <000e01cf3f7b$6edcdfd0$4c969f70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH38nvn9YEu8kZACW43ysqVfjw4YwJJQYvFmnzHSUA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t8zI939b5SCDSb2ClrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJUxY+5kxoLvnBV7twY0MLZxdDFyckgImEjsPbmUBcIW
	k7hwbz1bFyMXh5DAMkaJBT/Ws8AU3d3/mAkisYhR4umNRhYI5x+jRM/nqawgVWwCWhKr5x5n
	BLFFBHQkVuxaC9bBLDCdVeJXx1uojg5GiQ8PjzKDVHEKBEtsPdrIDmILC3hJ3PswhwnEZhFQ
	lbjxbwZYnFfAUmJe63QmCFtQ4sfke2A3MQNtW7/zOBOELS+xec1bZohbFSR2nH0NdYWVxKX9
	39ghakQk9r14xwhyhITAAQ6Ji8tOsEAsE5D4NvkQkM0BlJCV2HQAao6kxMEVN1gmMErMQrJ6
	FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIWmjbwfjzQPWhxiTgdZP
	ZJYSTc4Hpp28knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cBYW3pnQ3xho+2jLw8dcpkN99WVmwitnHjtzZHvt99c/N1vV61Xd7ZCO9+J75Zy+I8t
	6Yk7zRfHH96vyVh7Y/vlexXFXlPnXGeJElrEci9c+ZLhpLmVldLrf0kEZ91j6J+1TmP/Bzcn
	zmUz7y+eZsZTJ+Pauif/7/b8edoM//abS9+TkjDJfPpQiaU4I9FQi7moOBEAixF2pDEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jAd39b5SCDTqPcFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY8bcyYwF3zkr
	9m4NaGBs4+hi5OSQEDCRuLv/MROELSZx4d56ti5GLg4hgUWMEk9vNLJAOP8YJXo+T2UFqWIT
	0JJYPfc4I4gtIqAjsWLXWiaQImaB6awSvzreQnV0MEp8eHiUGaSKUyBYYuvRRnYQW1jAS+Le
	hzlg+1gEVCVu/JsBFucVsJSY1zqdCcIWlPgx+R4LiM0MtG39zuNMELa8xOY1b5khblWQ2HH2
	NdQVVhKX9n9jh6gRkdj34h3jBEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJEZyUnknvYFzVYHGIUYCDUYmHd8ZRxWAh1sSy4srcQ4wSHMxKIrwnHysFC/Gm
	JFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MGHmlcQbGpuYGVkamVkYmZibkyasJM57sNU6UEgg
	PbEkNTs1tSC1CGYLEwenVANjpRXDj63tHx2kZWd/81vp23BW/bjB5MhoiX2S0UdmsQjpOJzR
	7J2xatHcGbEXz6tMEl61XLB/U+WqFAHzP3a9XJPXvlNf/mSafED0ltT2rUqC87K5GGdG1T3c
	zPuI6+6Oo6t7ujWbVRlnO0qtUA70+ldx9bTNBLkY/uk5Oe8SP+vxbuF7+f+OEktxRqKhFnNR
	cSIA94je8o4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Friday, March 14, 2014 7:00 PM
> 
> On 14 March 2014 10:31, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from
> > exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without
> > removing remaining use of it from exynos-iommu driver, thus causing a
> > compilation error.
> >
> > This patch fixes the error by removing respective include line
> > from exynos-iommu.c.
> >
> > CC: Tomasz Figa <t.figa@samsung.com>
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 0740189..4876d35 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -12,6 +12,7 @@
> >  #define DEBUG
> >  #endif
> >
> > +#include <linux/kernel.h>
> 
> This change doesn't look related to the patch subject/description.
> 
Yes. But it is simply added without any side-effect.
Do you think it should be in a separate patch?.
Actually, the added line is a redundant.

Regards,

KyongHo.

