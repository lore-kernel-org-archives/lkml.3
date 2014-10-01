Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaJAC76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:59:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18071 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaJAC74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:59:56 -0400
X-AuditID: cbfee68e-f79b46d000002b74-e4-542b6e295409
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, linux@arm.linux.org.uk, naushad@samsung.com,
        tomasz.figa@gmail.com, thomas.ab@samsung.com, vikas.sajjan@samsung.com
References: <1412072481-22370-1-git-send-email-pankaj.dubey@samsung.com>
 <1412072481-22370-3-git-send-email-pankaj.dubey@samsung.com>
 <11948982.c37J1JPj8N@wuerfel>
In-reply-to: <11948982.c37J1JPj8N@wuerfel>
Subject: RE: [PATCH v8 2/2] ARM: EXYNOS: Move PMU specific definitions from
 common.h
Date: Wed, 01 Oct 2014 08:29:16 +0530
Message-id: <002401cfdd23$b538dbf0$1faa93d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHMb/JvJsabngpOST4hYk+TYuobyQGE0hIxAcZ+WEucBwyKgA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkTlcrTzvE4FKtxd9Jx9gtehdcZbPY
	9Pgaq8XlXXPYLGac38dkcfsyr8Wno/9ZLTqWMVqs2vWH0eLms+1MDlweLc09bB6/f01i9Ng5
	6y67x+Yl9R59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CVcfHgQuaC2+wVh6b3MzYwzmHrYuTk
	kBAwkXj7/x47hC0mceHeerC4kMBSRonlD8VhatZMfc4KEZ/OKLF2XSKE/ZdR4sqJShCbTUBX
	4sn7ucwgtoiAp8SZkwtYuhi5OJgFLjNKzLp7lh2iYTmjxKJfAiA2p4CWxNxp28GGCguESZxY
	tQWsmUVAVWL3wxawI3gFLCU6Ni9ghrAFJX5MvscCYjMD9a7feZwJwpaX2LzmLTPEoQoSO86+
	ZoQ4wkni7ptZbBA14hKTHjxkBzlIQuAvu8SXF8tZIJYJSHybfAjI5gBKyEpsOgA1R1Li4Iob
	LBOATkeyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIHRffrfs74d
	jDcPWB9iFOBgVOLhVUjQDhFiTSwrrsw9xGgKdNFEZinR5HxgCskriTc0NjOyMDUxNTYytzRT
	EudNkPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoExh8MutvHFtLrQN1xLHC2KJu+Zs3gH
	y40r5w+2/7I+Hxma8/7LYeEdNnz8V96p2m2+L/+j3k9Ek0tg7eawaq0p8o8YH9UdnL/CdE3M
	u3jDdM2HHEsy3Hc+5+Irj53l/E6j+1lO40k7tp+FkTlHOJaXP57j4r5p9jIGmV//8vlFp5Qe
	CpBfmPldiaU4I9FQi7moOBEAxHtAOekCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQV3NPO0Qg3UbzCz+TjrGbtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktPh39z2rRsYzRYtWuP4wWN59tZ3Lg8mhp7mHz+P1rEqPH
	zll32T02L6n36NuyitHj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZFw8uZC64zV5xaHo/YwPjHLYuRk4OCQETiTVTn7NC2GISF+6tB4sLCUxnlFi7LhHC/sso
	ceVEJYjNJqAr8eT9XGYQW0TAU+LMyQUsXYxcHMwClxklZt09yw7RsJxRYtEvARCbU0BLYu60
	7WALhAXCJE6s2gLWzCKgKrH7YQvYMl4BS4mOzQuYIWxBiR+T77GA2MxAvet3HmeCsOUlNq95
	ywxxqILEjrOvGSGOcJK4+2YWG0SNuMSkBw/ZJzAKzUIyahaSUbOQjJqFpGUBI8sqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjOD08UxqB+PKBotDjAIcjEo8vAoJ2iFCrIllxZW5hxglOJiV
	RHg3yAOFeFMSK6tSi/Lji0pzUosPMZoCfTqRWUo0OR+Y2vJK4g2NTcxNjU0tTSxMzCyVxHkP
	tFoHCgmkJ5akZqemFqQWwfQxcXBKNTCmbJRIuXA5q+fAmfn75YOO+1aYe7MUrhTcXpvRcz2o
	b+lDrbCzLVc9Qv/dXniVQcz90ss8z//hblwv5ytIvnwfdF+OP7R2UmJ9391ywxnHxM9N3azt
	f+LOH5/OaQ5tDkeePF3PL1X+SPb7GomA78pyT0JuzT74+LncoQWJnh/s/im9LM++WHJBiaU4
	I9FQi7moOBEAub3hwjUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tuesday, September 30, 2014 4:09 PM, Arnd Bergmann wrote,
> To: linux-arm-kernel@lists.infradead.org
> Cc: Pankaj Dubey; linux-kernel@vger.kernel.org;
linux-samsung-soc@vger.kernel.org;
> kgene.kim@samsung.com; linux@arm.linux.org.uk; naushad@samsung.com;
> tomasz.figa@gmail.com; thomas.ab@samsung.com; vikas.sajjan@samsung.com
> Subject: Re: [PATCH v8 2/2] ARM: EXYNOS: Move PMU specific definitions
from
> common.h
> 
> On Tuesday 30 September 2014 15:51:21 Pankaj Dubey wrote:
> >
> > +static inline void pmu_raw_writel(u32 val, u32 offset) {
> > +       __raw_writel(val, pmu_base_addr + offset); }
> > +
> > +static inline u32 pmu_raw_readl(u32 offset) {
> > +       return __raw_readl(pmu_base_addr + offset); }
> > +
> >
> 
> While you're at it, please convert these to use readl_relaxed() instead,
which is safe to
> use in drivers and works independent of CPU endianess.
> 

OK, I will update this. 

Thanks,
Pankaj Dubey
> 	Arnd

