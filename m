Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbaGEHKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 03:10:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51138 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760686AbaGEHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 03:10:06 -0400
X-AuditID: cbfee68f-b7fef6d000003970-b2-53b7a4cbe624
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-6-git-send-email-pankaj.dubey@samsung.com>
 <53B19B42.1040006@samsung.com>
In-reply-to: <53B19B42.1040006@samsung.com>
Subject: RE: [PATCH v5 5/5] ARM: EXYNOS: Move PMU specific definitions from
 common.h
Date: Sat, 05 Jul 2014 12:40:45 +0530
Message-id: <001f01cf9820$3f0ee570$bd2cb050$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK9JhWRh3pvFez7a+k3zuvbSuvV7QFYwQqgAkt3hiuZmNJHwA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkSvf0ku3BBl/u61ksm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBbrZ7xmsehYxmhx89l2Jgduj5bmHjaP
	zUvqPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugStj2cHTzAX7eCr+3r7D1MD4gLOLkZNDQsBE
	ouPsJ0YIW0ziwr31bF2MXBxCAksZJV6fOcYOU/Rzxy1WiMR0RomNHw5BOX8ZJV409TGBVLEJ
	6Eo8eT+XGSQhItDPKDG78RzYLGaBJYwSe2acYoRoWcEo0bH2DRtIC6eAtsSi3k8sILawQJjE
	yYNNYAtZBFQl1h2bCxbnFbCUmPfuFBOELSjxY/I9sDizgJbE+p3HmSBseYnNa94yQxyrILHj
	7Guwj0QEnCQW/lvHCFEjLjHpwUN2kCMkBBo5JG7t/8sKsUxA4tvkQ0BDOYASshKbDkDNkZQ4
	uOIGywRGiVlIVs9CsnoWktWzkKxYwMiyilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwvk//
	e9a/g/HuAetDjMlA6ycyS4km5wPTQ15JvKGxmZGFqYmpsZG5pRlpwkrivPcfJgUJCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYJT49Pby+ngt62kBgsLK0gKTTFV3Zwp6re1YfPuL066aL2c9
	V26dOPWY853ks6o7I+JXbORtLngy+Y/T9IxE1q/rPbWY9stv5uqb4vr3iKbK4S+9sautY1hi
	J7169uCF4PK+1/ozMo3KXmhekOZwnF9ksUlnplvpooLSWv7nmld87gl8TJgouVaJpTgj0VCL
	uag4EQDhBLNTBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd3TS7YHG8zdo2qxbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1qsn/GaxaJjGaPFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGcsO
	nmYu2MdT8ff2HaYGxgecXYycHBICJhI/d9xihbDFJC7cW8/WxcjFISQwnVFi44dDrBDOX0aJ
	F019TCBVbAK6Ek/ez2UGSYgI9DNKzG48B9bCLLCEUWLPjFOMEC0rGCU61r5hA2nhFNCWWNT7
	iQXEFhYIkzh5sIkdxGYRUJVYd2wuWJxXwFJi3rtTTBC2oMSPyffA4swCWhLrdx5ngrDlJTav
	ecsMcayCxI6zrxlBbBEBJ4mF/9YxQtSIS0x68JB9AqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECE4ez6R3MK5qsDjEKMDBqMTDq3BsW7AQa2JZcWXuIUYJ
	DmYlEd7SxduDhXhTEiurUovy44tKc1KLDzGaAn06kVlKNDkfmNjySuINjU3MTY1NLU0sTMws
	lcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUw2nHM3P5jTohr8OGHL35mS3vfvGTRm3DlblYS
	xzbLkKWmzC9UTC/Iz7+Q2+SXbCuatWuLyoMjKmx1BVaZd4sNY2OsM6Z9U5o6feNRORbVtKyL
	DGs/GivLTpHZzGPJwRxev3HNzBlsjVXpLW7/BN9ryN7xliiv/ZX48afywefHi+87mhjO6+lT
	YinOSDTUYi4qTgQA8azBazQDAAA=
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
> > This patch moves PMU specific definitions into a new file as
> > exynos-pmu.h.
> > This will help in reducing dependency of common.h in pmu.c.
> >
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> >  arch/arm/mach-exynos/common.h     |   17 -----------------
> >  arch/arm/mach-exynos/exynos-pmu.h |   31
> +++++++++++++++++++++++++++++++
> >  arch/arm/mach-exynos/pm.c         |    1 +
> >  arch/arm/mach-exynos/pmu.c        |    2 +-
> >  4 files changed, 33 insertions(+), 18 deletions(-)  create mode
> > 100644 arch/arm/mach-exynos/exynos-pmu.h
> >
> > diff --git a/arch/arm/mach-exynos/common.h
> > b/arch/arm/mach-exynos/common.h index 296c6e1..0326ca2 100644
> > --- a/arch/arm/mach-exynos/common.h
> > +++ b/arch/arm/mach-exynos/common.h
> > @@ -135,23 +135,6 @@ extern struct smp_operations exynos_smp_ops;
> >
> >  extern void exynos_cpu_die(unsigned int cpu);
> >
> > -/* PMU(Power Management Unit) support */
> > -
> > -#define PMU_TABLE_END	(-1U)
> > -
> > -enum sys_powerdown {
> > -	SYS_AFTR,
> > -	SYS_LPA,
> > -	SYS_SLEEP,
> > -	NUM_SYS_POWERDOWN,
> > -};
> > -
> > -struct exynos_pmu_conf {
> > -	unsigned int offset;
> > -	unsigned int val[NUM_SYS_POWERDOWN];
> > -};
> 
> While at it, I'd say this struct could be moved to pmu.c, along with the
> PMU_TABLE_END macro as they are both private to this file.
> 

OK, I will update this.

> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

