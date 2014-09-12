Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaILJYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:24:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18124 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaILJYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:24:36 -0400
X-AuditID: cbfee68e-f79536d000000fd1-77-5412bbcbd96f
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, s.nawrocki@samsung.com, mturquette@linaro.org,
        "'Chander Kashyap'" <k.chander@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>
References: <1410328565-25122-1-git-send-email-pankaj.dubey@samsung.com>
 <54122962.5020903@gmail.com>
In-reply-to: <54122962.5020903@gmail.com>
Subject: RE: [PATCH] clk: samsung: exynos5260: fix typo in clock name
Date: Fri, 12 Sep 2014 14:57:04 +0530
Message-id: <000e01cfce6b$bf538ca0$3dfaa5e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGjcMNdvmvoOe4ebVgYUdsP7pvQZwFqBtAdnEqku5A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkSvf0bqEQgyOrFSwer1nMZLFqwxIW
	i94FV9ksNj2+xmpxedccNosZ5/cxWTydcJHN4vCbdlaLVbv+MDpweuycdZfd4861PWwem5fU
	e/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGwycf2Qq6OCtuLb/E2sC4h72LkZNDQsBEYsGS
	d2wQtpjEhXvrgWwuDiGBpYwSOxsusMIUHZ55jwkiMZ1R4ujM72AdQgJ/GSWutiqB2GwCuhJP
	3s9lBikSEZjCKLFycyuYwyywmFHi7NOdLBAd6RKX9k8Gsjk4OAU0JXaf1QMJCwu4ShxpucEM
	YrMIqEpcud0AtoBXwFJiTdcDRghbUOLH5HtgY5gFtCTW7zzOBGHLS2xe85YZ4lIFiR1nX4PV
	iwhYSaxrWARVIy4x6cFDdpB7JAR+skusXbKFDWKZgMS3yYfA7pEQkJXYdABqjqTEwRU3WCYw
	SsxCsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiBMX3637O+HYw3
	D1gfYhTgYFTi4a1gEQwRYk0sK67MPcRoCnTRRGYp0eR8YOLIK4k3NDYzsjA1MTU2Mrc0UxLn
	TZD6GQwMw8SS1OzU1ILUovii0pzU4kOMTBycUg2M3Mu2reqxDNcIlV+zeurMMyYS7en777gc
	WzVfyV/25ZqiJP63+0vzlEs/OcSldd59zxV20DLZxu3ji8M2bhO7p6caNdysevfaP/0M092u
	Vb69N76LekkqdVu8+bSqQHvV3+c7LOftWruq5VmM3aeVa8MqtTNnnhf4djOyPdZI7EXl6Y3F
	8pfPK7EUZyQaajEXFScCAMzT1HbkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd3Tu4VCDB7tErN4vGYxk8WqDUtY
	LHoXXGWz2PT4GqvF5V1z2CxmnN/HZPF0wkU2i8Nv2lktVu36w+jA6bFz1l12jzvX9rB5bF5S
	79G3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2
	Si4+AbpumTlABykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMx4++chW
	0MVZcWv5JdYGxj3sXYycHBICJhKHZ95jgrDFJC7cW8/WxcjFISQwnVHi6MzvbCAJIYG/jBJX
	W5VAbDYBXYkn7+cygxSJCExhlFi5uRXMYRZYzChx9ulOFoiOdIlL+ycD2RwcnAKaErvP6oGE
	hQVcJY603GAGsVkEVCWu3G4AW8ArYCmxpusBI4QtKPFj8j2wMcwCWhLrdx5ngrDlJTavecsM
	camCxI6zr8HqRQSsJNY1LIKqEZeY9OAh+wRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iRGcMJ5J7WBc2WBxiFGAg1GJh7eCRTBEiDWxrLgy9xCjBAezkgjv
	z21CIUK8KYmVValF+fFFpTmpxYcYTYE+ncgsJZqcD0xmeSXxhsYm5qbGppYmFiZmlkrivAda
	rQOBwZVYkpqdmlqQWgTTx8TBKdXAyF1QcDTNwOMef57ZKf3JNedfHvQrPOVTbh/4+2JHdEvf
	4WOzYtM71ycfVvvzS/rOzfDVC7k/vm36pL7ulSBzV8X1Xp71LdlmHL1MvWXnHs5IVf9+8Ned
	aWp1V0qvGp16sNU329z3b1bjyyPnc3PWrjn03pexrNrwucRuq1fRnA8vWwgzt655qcRSnJFo
	qMVcVJwIAB+z+CMuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

> -----Original Message-----
> From: Tomasz Figa [mailto:tomasz.figa@gmail.com]
> Sent: Friday, September 12, 2014 4:30 AM
> To: Pankaj Dubey; linux-arm-kernel@lists.infradead.org; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: kgene.kim@samsung.com; s.nawrocki@samsung.com; mturquette@linaro.org;
> Chander Kashyap; Abhilash Kesavan
> Subject: Re: [PATCH] clk: samsung: exynos5260: fix typo in clock name
> 
> Hi Pankaj,
> 
> On 10.09.2014 07:56, Pankaj Dubey wrote:
> > From: Chander Kashyap <k.chander@samsung.com>
> >
> > The parent name added in parent list as
> > mout_phyclk_mipi_dphy_4l_m_txbyte_clkhs_p, is different than the
> > defined parent due to typo.
> >
> > Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> > Signed-off-by: Chander Kashyap <k.chander@samsung.com>

Please add my sign-off as 

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>

> 
> Missed your sign-off? You can reply with it inline and I will add it when
applying this
> weekend.
> 
> P.S. Please keep me on CC when sending patches for Samsung clock drivers.
> 
> Best regards,
> Tomasz

