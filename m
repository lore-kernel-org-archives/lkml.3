Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbaGEGfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 02:35:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25872 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaGEGe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 02:34:58 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-a7-53b79c9161d1
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-4-git-send-email-pankaj.dubey@samsung.com>
 <53B18E52.1060906@samsung.com>
In-reply-to: <53B18E52.1060906@samsung.com>
Subject: RE: [PATCH v5 3/5] ARM: EXYNOS: Move "mach/map.h" inclusion from
 regs-pmu.h to platsmp.c
Date: Sat, 05 Jul 2014 12:05:39 +0530
Message-id: <001d01cf981b$57829bb0$0687d310$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK9JhWRh3pvFez7a+k3zuvbSuvV7QNoGbCNAwcQjkCZgnDS0A==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkTnfinO3BBqtmq1ssm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBbrZ7xmsehYxmhx89l2Jgduj5bmHjaP
	zUvqPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvjw73JTAVz2Sq+3L7F3MD4lqWLkZNDQsBE
	Ym7LPnYIW0ziwr31bF2MXBxCAksZJZacmMkGU3Rg4m9GiMR0Rolri7ezQDh/GSVOnTvKCFLF
	JqAr8eT9XGaQhIhAP6PE7MZzYLOYBZYwSuyZcQqqfwWjROv/aUxdjBwcnALaEhf/8oJ0Cwsk
	S5ze18AMYrMIqEqcubaYFcTmFbCUaP7/kQ3CFpT4Mfke2OHMAloS63ceZ4Kw5SU2r3nLDHGr
	gsSOs6/BLhIRcJJ40nMcql5cYtKDh+wgN0gItHJILDhyixVimYDEt8mHWEDukRCQldh0AGqO
	pMTBFTdYJjBKzEKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIHR
	ffrfs74djDcPWB9iTAZaP5FZSjQ5H5gc8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDo/R2Po1gX7PpO9hPKX9LspxSGP3J9QjHx9t2GY+YWRT/
	TVvo93rm7o3OFyRqs6sKf4gcXGn7ZtPtSjYz/gmJi1u7zJPbNokekpppvmSn1ve/E1amnbU7
	++tTVdmDcOV32dpBcvr+m8VPvDUxuXn4rs3NQxavPqt9tlr2elG2nhPHwfVr2YSj8pRYijMS
	DbWYi4oTAdER3VQEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd2Jc7YHG7zdK2exbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1qsn/GaxaJjGaPFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGR/u
	TWYqmMtW8eX2LeYGxrcsXYycHBICJhIHJv5mhLDFJC7cW8/WxcjFISQwnVHi2uLtLBDOX0aJ
	U+eOglWxCehKPHk/lxkkISLQzygxu/EcWAuzwBJGiT0zTjFCtKxglGj9P42pi5GDg1NAW+Li
	X16QbmGBZInT+xqYQWwWAVWJM9cWs4LYvAKWEs3/P7JB2IISPybfA7uPWUBLYv3O40wQtrzE
	5jVvmSFuVZDYcfY12EUiAk4ST3qOQ9WLS0x68JB9AqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECE4dz6R3MK5qsDjEKMDBqMTDq3BsW7AQa2JZcWXuIUYJ
	DmYlEd6KkO3BQrwpiZVVqUX58UWlOanFhxhNgT6dyCwlmpwPTGt5JfGGxibmpsamliYWJmaW
	SuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoY9SaId7TKbp3fLzVTaur3z1fUzwa79Zy6wp1k
	dXX97zM/5r08doyxhXGa6otnR2esWj85Z9EdFTPnmXqM84NOVR67ZBjvyl0rd9v4x/nz+pt/
	dz1c0q/GOv+e0Fbtx99SLm+a971qpULr09NGUXLnBB5NKHr/RuxPuMfG9cxuxj1pUresriZ5
	ViuxFGckGmoxFxUnAgBSJXk/MwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Monday, June 30, 2014 Tomasz Figa wrote:
> Hi Pankaj,
> 
> On 25.06.2014 16:03, Pankaj Dubey wrote:
> > As we have removed static mappings from "regs-pmu.h" it does not need
> > map.h anymore. But "platsmp.c" needed this and till now it got
> > included indirectly. So lets move header inclusion of "mach/map.h"
> > from "regs-pmu.h" to "platsmp.c".
> >
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> >  arch/arm/mach-exynos/platsmp.c  |    2 ++
> >  arch/arm/mach-exynos/regs-pmu.h |    2 --
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> 
> IMHO this could be squashed with previous patch.
> 

OK, will squash this.

> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

