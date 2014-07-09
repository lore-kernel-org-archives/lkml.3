Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaGIMmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:42:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53644 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaGIMmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:42:43 -0400
X-AuditID: cbfee61a-f79e46d00000134f-d9-53bd38c164b2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: EXYNOS: add Exynos3250 PMU support
Date: Wed, 09 Jul 2014 14:42:25 +0200
Message-id: <1640080.ftkUyQnINn@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <2933359.zRXLcIi25R@amdc1032>
References: <2933359.zRXLcIi25R@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd2DFnuDDabM07C4/uU5q0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsli09Qu7xfoZr1ksbj7bzuTA6bF5Sb1H35ZVjB6fN8kF
	MEdx2aSk5mSWpRbp2yVwZXzecIy94Cp7xdOOPsYGxhtsXYycHBICJhLTZn1jgrDFJC7cWw8U
	5+IQEpjOKLFvy15WCKeFSWLz159gHWwCVhIT21cxgtgiAmoSPYu3MoIUMQtsY5Jo3voabJSw
	gL3E+fdzwIpYBFQlTq3ZyQJi8wpoSixvuwc2SFTAU2LH9pVANgcHp4CWxN5lPiBhIaCSN+ve
	MkKUC0r8mHwPrJVZQF5i3/6prBC2lsT6nceZJjAKzEJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBAf5M6kdjCsbLA4xCnAwKvHwKvDsCRZiTSwrrsw9xCjBwawkwmts
	ujdYiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA2NN1rlF
	nHaWkUGLTje187PIPfOL/tj+bV2yoegMlx0eKz7qX/nN4TMh21X2s9rFN8WP6ypX676ZGMQv
	F/LxxovCve1dwstE1dwu/DB44NrIscY+X/bUB/30n7v/svY9Ypnfqs4uFHzx1JK5y3erskvq
	f7/todO+4CLnBIvbRS1TXH9e0n37SFGJpTgj0VCLuag4EQBlsnBcbgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2014 02:39:14 PM Bartlomiej Zolnierkiewicz wrote:
> This is needed for suspend/resume and cpuidle AFTR mode support.
> 
> Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
> Cc: Vikas Sajjan <vikas.sajjan@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---

Changelog for v2:

- rebased on top of next-20140708 and
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32410.html
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33660.html
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33675.html

  this patchset also applies fine after/before Exynos5800 PMU support:
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33835.html

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

