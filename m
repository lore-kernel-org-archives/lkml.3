Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbaEFCe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:34:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59266 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbaEFCey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:34:54 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a1-53684a4d662c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Tomasz Stanislawski'" <t.stanislaws@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        j.anaszewski@samsung.com,
        =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>
References: <534D4143.3050801@samsung.com> <53594496.4010607@samsung.com>
In-reply-to: <53594496.4010607@samsung.com>
Subject: RE: [PATCH] arm: dts: exynos4412-trats2: rename alias for i2c_ak8975
 label
Date: Tue, 06 May 2014 11:34:52 +0900
Message-id: <098d01cf68d3$c2420b10$46c62130$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8wzRZu5e3m6UdmYMT6niTju0uVAHqV4wwmkjOStA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t8zA11fr4xgg+5lHBYbZ6xntZi07gCT
	xfwj51gt+t8sZLU492olo0Xv1eeMFmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi6fWLTBYT
	pq9lsWjde4TdYv2M1ywW89pfsjoIeKyZt4bRo6W5h83jcl8vk8ffVS+YPVYu/8LmsWlVJ5vH
	5iX1Hn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJXxd0kva8FMrorOlYdYGhh7OboYOTgkBEwk
	Og7IdzFyApliEhfurWfrYuTiEBJYxihx7eN0ZoiEicS8DT9ZIRKLGCUautYwgiSEBP4ySvyZ
	Zw5iswloSBx+/4wdZKiIQJTE0RlpIPXMAi0sEq3nb7NA1HtKHLy9ih3E5hTQlph+ZjVYXFgg
	VKJ3Tw/YMhYBVYm1jYfA5vMKWEqc2jmLDcIWlPgx+R5YPbOAusSkeYuYIWx5ic1r3kIdqiCx
	4+xrsF4RASuJtSdeQNWISOx78Y4R5CAJgTMcEqc/PmSDWCYg8W3yIRZISMhKbDoANUdS4uCK
	GywTGCVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkNTRv4Px
	7gHrQ4zJQOsnMkuJJucDU09eSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamBMfvvMSKH+2M5s7p9bDz7+VNo1J2GKifKK6LfrfUrSd55hmiGzJV38
	a/GKHzUxmXdSPu2dPKGzdupfwdWTooQPzvxy9oPSlOefVM/N/+USX65qsKjfyuXwEseNC569
	Prfl59wTS790f/Cexc3LureNtV7hxZJ81eZPfLJLw17LL1v6Ys+z1mN3LJVYijMSDbWYi4oT
	AeZBVR8zAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t9jAV1fr4xgg2N3mSw2zljPajFp3QEm
	i/lHzrFa9L9ZyGpx7tVKRoveq88ZLc42vWG32PT4GqvF5V1z2CxmnN/HZHH7Mq/F0usXmSwm
	TF/LYtG69wi7xfoZr1ks5rW/ZHUQ8Fgzbw2jR0tzD5vH5b5eJo+/q14we6xc/oXNY9OqTjaP
	zUvqPfq2rGL0+LxJLoAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoDSWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxt8l
	vawFM7kqOlceYmlg7OXoYuTkkBAwkZi34ScrhC0mceHeerYuRi4OIYFFjBINXWsYQRJCAn8Z
	Jf7MMwex2QQ0JA6/f8bexcjBISIQJXF0RhpIPbNAC4tE6/nbLBD1nhIHb69iB7E5BbQlpp9Z
	DRYXFgiV6N3TwwxiswioSqxtPAQ2n1fAUuLUzllsELagxI/J98DqmQXUJSbNW8QMYctLbF7z
	lhniUAWJHWdfg/WKCFhJrD3xAqpGRGLfi3eMExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRnBqeia1g3Flg8UhRgEORiUe3hMr04OFWBPLiitzDzFKcDAr
	ifD6O2UEC/GmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MG3mlcQbGpuYGVkamVkYmZibkyas
	JM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANj21zv4JDqT+uDnWQibJ4fFY77sTP20MMd+Qte
	fOl+ss3D/EGf0Mr4OrFn5h8ClB6V7Pfg3xGee/Adv+G+A7vvvXj96HFz/wPdOo7PRuqHYu+y
	PTy8o9JZiE/qmKyh3+w4Qb55l3o/HbFNWrCmaXXf+RWRj6c8NvWM2d1fpVuU5fXH/HHCtQtp
	SizFGYmGWsxFxYkAsQsT+ZEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Tomasz,
> 
> On 15.04.2014 16:25, Tomasz Stanislawski wrote:
> > The i2c_ak8975 controler uses label i2c8.
> > This alias is already used for I2C controller 8 defined
> > in file arch/arm/boot/dts/exynos4.dtsi.
> >
> > This patch renames a label for i2c_ak8975 to i2c9.
> >
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > ---
> >   arch/arm/boot/dts/exynos4412-trats2.dts |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts
> b/arch/arm/boot/dts/exynos4412-trats2.dts
> > index c16b315..5add765 100644
> > --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> > +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> > @@ -20,7 +20,7 @@
> >   	compatible = "samsung,trats2", "samsung,exynos4412",
> "samsung,exynos4";
> >
> >   	aliases {
> > -		i2c8 = &i2c_ak8975;
> > +		i2c9 = &i2c_ak8975;
> >   	};
> >
> >   	memory {
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-samsung-
> soc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Seems reasonable.
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
Applied, thanks.

- Kukjin

