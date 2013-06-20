Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363Ab3FTLEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:04:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8199 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291Ab3FTLEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:04:49 -0400
X-AuditID: cbfee68e-b7f276d000002279-e1-51c2e1d0d202
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
 <3250954.dVh4O1LchK@flatron> <00c501ce6d8f$af1bf900$0d53eb00$@samsung.com>
 <201306201216.37248.arnd@arndb.de>
In-reply-to: <201306201216.37248.arnd@arndb.de>
Subject: Re: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 20:04:47 +0900
Message-id: <00d801ce6da5$fa792d80$ef6b8880$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKCeiqjUMDl9MJHZtKATS766DS40AJuOCeeApDbf08Bt/tERJegnpqg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t8zfd0LDw8FGlzbImvR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MFqt2/WF0EPJYM28No8fvX5MYPfqmXGXzeLLpIqPH
	zll32T0WbCr1uHNtD5vH5iX1HudnLGT0+L6jF6hqyypGj58vdTw+b5IL4I3isklJzcksSy3S
	t0vgyrh4YhlbwS/2is+r1zM2MF5g7WLk5JAQMJE4teMmO4QtJnHh3nq2LkYuDiGBZYwSSx8f
	YIEp2r/iHliDkMAiRonFzxQgin4xSvSvfAVWxCagJvHly2GwSSICyhLHX95hASliFnjOKtFx
	/wwrRMdqRon5M3YwglRxCuhLvL79lQ3EFhaIlniyuIkJxGYRUJWY9P0T2DpeAUuJlxMWMULY
	ghI/Jt8D28YsoCWxfudxJghbXmLzmrfMEKcqSOw4+5oR4go3iZNdb1ghakQk9r14xwhyhITA
	Bw6JbxuOMEMsE5D4NvkQ0FAOoISsxKYDUHMkJQ6uuMEygVFiFpLVs5CsnoVk9SwkKxYwsqxi
	FE0tSC4oTkovMtIrTswtLs1L10vOz93ECEk7fTsYbx6wPsSYDLR+IrOUaHI+MG3llcQbGpsZ
	WZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRwM5F8uf/K7Wm
	3gZfu1vuuyzIZ7t7+Xgd5yWJmZnOwXunB/RYKhYzNwodyFhVWhDh8sjT9oH6n9c/1R4839lj
	cDNk8WQJh+c3Jv4T5t76XuGQyCytzaZlkyLcbh07cnap699pvhOEhTcEl/FWbvp8MYDpyMxv
	3EnKzl+nn9Zv3B8aFrjxYtpTJZbijERDLeai4kQA6f7rRFEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsVy+t9jAd0LDw8FGrTMFrdo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmi1W7/jA6CHmsmbeG0eP3r0mMHn1TrrJ5PNl0kdFj
	56y77B4LNpV63Lm2h81j85J6j/MzFjJ6fN/RC1S1ZRWjx8+XOh6fN8kF8EY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8y4eGIZW8Ev9orPq9czNjBeYO1i5OSQEDCR2L/i
	HpQtJnHh3no2EFtIYBGjxOJnCl2MXED2L0aJ/pWvWEASbAJqEl++HGYHsUUElCWOv7zDAlLE
	LPCcVaLj/hlWiI7VjBLzZ+xgBKniFNCXeH37K9hYYYFoiSeLm5hAbBYBVYlJ3z+BreYVsJR4
	OWERI4QtKPFj8j2wbcwCWhLrdx5ngrDlJTavecsMcaqCxI6zrxkhrnCTONn1hhWiRkRi34t3
	jBMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwUnsmvYNx
	VYPFIUYBDkYlHl6NywcDhVgTy4orcw8xSnAwK4nwps45FCjEm5JYWZValB9fVJqTWnyIMRno
	04nMUqLJ+cCEm1cSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jAzJ70wbneOv5M/8ssuGo1bM8tGbe2G3Fjkai8tfDj9x+LH1vtyCOudFjYvTrRZ/0lI5uoMx
	QOqq8K19r2+Wfbits7xu+Tf7nUqeXu8/7Z7w/tf1JEm1m+FTfh60XRw2PXR/tF+Ci7mm3A33
	Al+DlADJTR+3+jxNMFL+87ZleuCz3L1LYssZo5RYijMSDbWYi4oTAdZoaZmuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 20, 2013 7:17 PM, Arnd Bergmann wrote:
> On Thursday 20 June 2013, Jingoo Han wrote:
> > 2. patch adding label to the pinctrl node (which is a prerequisite) and
> >     board-specific properties of PCIe nodes.
> >    [PATCH] ARM: dts: Add pcie controller node for exynos5440-ssdk5440
> >
> > arch/arm/boot/dts/exynos5440-ssdk5440.dts
> > +
> > +       pcie0@290000 {
> > +               reset-gpio = <&pin_ctrl 5 0>;
> > +       };
> > +
> > +       pcie1@2a0000 {
> > +               reset-gpio = <&pin_ctrl 22 0>;
> > +       };
> >
> > arch/arm/boot/dts/exynos5440.dtsi
> > -       pinctrl {
> > +       pin_ctrl: pinctrl {
> >
> 
> Note that you don't really have to use a label, you can also refer
> to the pinctrl node by its full path, which is just "/pinctrl"
> or "/pinctrl@e0000".

I see.

But, I have a question.
Using phandle has been the usual way to referring to a node. 
Why do you want to do it differently?

Best regards,
Jingoo Han

> 
> 	Arnd

