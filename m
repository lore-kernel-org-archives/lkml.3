Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965875AbaDJJ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:57:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22629 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804AbaDJJ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:57:03 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-4e-53466aed8526
From: Chanho Park <chanho61.park@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        yj44.cho@samsung.com, inki.dae@samsung.com,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>, kyungmin.park@samsung.com,
        linux-samsung-soc@vger.kernel.org
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
 <1397122124-15690-3-git-send-email-cw00.choi@samsung.com>
 <4172202.teSeEmypAU@wuerfel>
In-reply-to: <4172202.teSeEmypAU@wuerfel>
Subject: RE: [PATCH 02/27] ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of
 Exynos3250
Date: Thu, 10 Apr 2014 18:57:02 +0900
Message-id: <002501cf54a3$38f50d60$aadf2820$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHswY/dwiExWmV8C5CYXcVGb5tK2AH5QtGuATUfGNeatk/HsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWyRsSkWPdtlluwwZQNEhZ/Jx1jt7j+5Tmr
	xecPLewWk+5PYLHoXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBYzJr9ks1g/4zWLxd6dkxkd
	eDx+/5rE6LF5Sb1H35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZTy6PoW54CV3xeF7E9gbGP9y
	djFyckgImEjMvP2JDcIWk7hwbz2QzcUhJLCUUeJIxwc2mKJnO7ayQiSmM0rMOLMYyvnHKHHl
	1GNGkCo2AV2JLc9fgdkiAp4SZ04uYAEpYhaYwiTRcb2BGaJjAaNEe9trdpAqTgFNiXML7zN1
	MXJwCAvESJy6GAISZhFQlViwfj8riM0rYClx5WIXI4QtKPFj8j0WEJtZQEti/c7jTBC2vMTm
	NW+ZIU5VkNhx9jXUEU4Sl/duYoaoEZHY9+IdI8gNEgK9HBLTnu9lglgmIPFt8iEWkBskBGQl
	Nh2AmiMpcXDFDZYJjBKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+
	7iZGYKSf/vds4g7G+wesDzEmA62fyCwlmpwPTBR5JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oK
	EhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4PvhkE//lGeKJa1RCDt5OWvNuQf56xejS6/Xc
	XDf2tJvu3cTwcV/+ujuZ/C8PrZHaEl188/wr7fY0m11TzPiZci63eyvcVFRMeBuUKO3GtE1I
	ezff2mduH38q2dernLxy/nv1KdXPgXtKefkO7466qnX6O3/VId3ERQ836JxveGB242rNDu8y
	JZbijERDLeai4kQA7Cmr3QoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jQd23WW7BBvdf8Vv8nXSM3eL6l+es
	Fp8/tLBbTLo/gcWid8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVnMmPySzWL9jNcsFnt3TmZ0
	4PH4/WsSo8fmJfUefVtWMXp83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA3SakkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwhjHj0fUpzAUvuSsO35vA3sD4l7OLkZNDQsBE4tmOrawQtpjEhXvr2boYuTiEBKYzSsw4
	s5gVwvnHKHHl1GNGkCo2AV2JLc9fgdkiAp4SZ04uYAEpYhaYwiTRcb2BGaJjAaNEe9trdpAq
	TgFNiXML7zN1MXJwCAvESJy6GAISZhFQlViwfj/Yal4BS4krF7sYIWxBiR+T77GA2MwCWhLr
	dx5ngrDlJTavecsMcaqCxI6zr6GOcJK4vHcTM0SNiMS+F+8YJzAKzUIyahaSUbOQjJqFpGUB
	I8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOA08kx6B+OqBotDjAIcjEo8vAeWuQYLsSaW
	FVfmHmKU4GBWEuHdnekWLMSbklhZlVqUH19UmpNafIgxGejTicxSosn5wBSXVxJvaGxiZmRp
	ZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MqW9/Xc/LWhe1jOefQkn5rSDH
	/9r6/2xY23orD5q3OK8UOnvVIvzK5eawM1ufPT6z6WpOxs6LGzWYubnDEt5v3MzfxpHlIhtj
	8tvg5RODjim7lrz/VPDC9en08ql+G9Q7V7RZCzzdNbXoCoPinWrzL3zqJu5VoetZmjW28bSz
	a92qqF96M/GuEktxRqKhFnNRcSIA2WKIdWcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> -----Original Message-----
> From: linux-arm-kernel [mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Arnd Bergmann
> Sent: Thursday, April 10, 2014 6:45 PM
> To: linux-arm-kernel@lists.infradead.org
> Cc: kgene.kim@samsung.com; t.figa@samsung.com; hyunhee.kim@samsung.com;
> sw0312.kim@samsung.com; linux-kernel@vger.kernel.org;
> yj44.cho@samsung.com; inki.dae@samsung.com; Chanwoo Choi;
> kyungmin.park@samsung.com; linux-samsung-soc@vger.kernel.org
> Subject: Re: [PATCH 02/27] ARM: EXYNOS: Add IO mapping for non-secure
> SYSRAM of Exynos3250
> 
> On Thursday 10 April 2014 18:28:19 Chanwoo Choi wrote:
> >
> > The non-secure SYSRAM is used for secondary CPU bring-up. This patch
> add
> > IO mapping for non-scure SYSRAM.
> >
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> I really don't want to see any further static mappings here. We had the
> same discussion for the previous Exynos chip that was submitted, so
> please
> describe the SYSRAM in DT, and start thinking about the other static
> mappings
> that can be removed.

Sachin already submitted the DT support[1] for SYSRAM area.

[1] : http://www.spinics.net/lists/linux-samsung-soc/msg27647.html

> 
> 	Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

