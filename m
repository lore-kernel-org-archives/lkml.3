Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaFQGn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 02:43:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46621 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaFQGnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 02:43:24 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-85-539fe376cca7
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-7-git-send-email-pankaj.dubey@samsung.com>
 <53973C0B.2000903@samsung.com>
In-reply-to: <53973C0B.2000903@samsung.com>
Subject: RE: [PATCH v4 06/11] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
Date: Tue, 17 Jun 2014 12:13:45 +0530
Message-id: <000401cf89f7$7db93190$792b94b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFbr3MzJH2VQYc81U++V3sC+P5mXwMhwgFEAtTNFXWcLNIycA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsWyRsSkWrfs8fxggxsblC2WTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxfsZrFoubz7YzOXB6tDT3sHlsXlLv0bdlFaPH
	501yASxRXDYpqTmZZalF+nYJXBnH12xjLbjDV/Hn+V3GBsZr3F2MnBwSAiYSTzfuZIewxSQu
	3FvPBmILCSxllFh0ThOm5sbdy4xdjFxA8UWMEquaV7JBOH8ZJfZePArWwSagK/Hk/VxmkISI
	QD+jxMutP1i7GDk4mAXKJKatUYFoWMEo8f7oFBaQBk4BbYnl/66B1QgLxEjsnK0HEmYRUJVY
	+WYSM4jNK2ApsW3PKlYIW1Dix+R7YK3MAloS63ceZ4Kw5SU2r3nLDHGpgsSOs68ZQWwRASeJ
	z90tjBA14hKTHjyE+vIru8TpVfwQuwQkvk0+xAJygoSArMSmA1BjJCUOrrjBMoFRYhaSzbOQ
	bJ6FZPMsJBsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiM4dP/nk3cwXj/gPUhxmSg
	9ROZpUST84EpIK8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGDl/Pk3VZWKp/HvZydAn61/i1ja+kNWnBXb9EFc/sIHTeNIVMUWOLQLRZmL/tl97
	9X71upWvX14yPtbVrGz8qlHkah6bzt3bd39LmTDvPyge3bFP7XqkMDeL4K7Pefs+L26Xn8dz
	ftLXRXWha9VXTPnGcZlhhrJ0Ao89x42mQn3PVkkR7qwlW5VYijMSDbWYi4oTAW+r7/z3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAd2yx/ODDU60SFssm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mddi/YzXLBY3n21ncuD0aGnuYfPYvKTeo2/LKkaP
	z5vkAliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmHF+zjbXgDl/Fn+d3
	GRsYr3F3MXJySAiYSNy4e5kRwhaTuHBvPVsXIxeHkMAiRolVzSuhnL+MEnsvHmUDqWIT0JV4
	8n4uM0hCRKCfUeLl1h+sXYwcHMwCZRLT1qhANKxglHh/dAoLSAOngLbE8n/XwGqEBWIkds7W
	AwmzCKhKrHwziRnE5hWwlNi2ZxUrhC0o8WPyPbBWZgEtifU7jzNB2PISm9e8ZYa4VEFix9nX
	YFeLCDhJfO5uYYSoEZeY9OAh+wRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iRGcJJ5J7WBc2WBxiFGAg1GJh/eh7PxgIdbEsuLK3EOMEhzMSiK8XOZAId6U
	xMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJrC8knhDYxNzU2NTSxMLEzNL0oSVxHkPtFoHCgmk
	J5akZqemFqQWwWxh4uCUamDk/93yYMblRPNLWScPvBBbmHflOnv3A7vjp+dnfUnfw/XpcpPi
	0f6b/ypNn+z8FZFuIX029LxPzbPWxfVTVcvc8gLMrp043y8eG9uq5rGXN1465zjvSx+jbMUr
	rkG7536rUbU5mpVV4n2nMJJR6Zv9u0qvjP2frBLtyops1rPFKLcpWlz9YarEUpyRaKjFXFSc
	CABBTb5UVgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

> Hi,
> 
> On 10.05.2014 08:56, Pankaj Dubey wrote:
> > From: Young-Gun Jang <yg1004.jang@samsung.com>
> >
> > Add support for mapping Samsung Power Management Unit (PMU) base
> > address from device tree. This patch also adds helper function as
> > "get_exynos_pmuregmap". This function can be used by other machine
> > files such as "pm.c", "hotplug.c" for accessing PMU regmap handle.
> >
> 
> I don't think there is a need to use regmap to provide access to PMU to
such low
> level code such as pm.c or hotplug.c. Moreover, I believe that it might be
undesirable
> in some cases, e.g. very low level code running at early resume or late
suspend.
> 
> IMHO, based on what we now have for SYSRAM, you could simply map PMU from
> device tree one time, before SMP init, and keep the address in some
globally
> accessible variable, like those for SYSRAM we have right now
(sysram_base_addr,
> sysram_ns_base_addr -> pmu_base_addr).
> 

Thanks for review. 

Well I adopted same approach in V1 of this patch series. 

V1: https://lkml.org/lkml/2014/4/2/48

So, if we do not have issues with that approach, I think we can map PMU
address
one time and use it for all machine files including pmu.c. 
Also I can see that early_syscon patch [1] is not progressing anymore,
so in next version of this series better I remove dependency of early syscon
and usage
of regmap.

1: https://lkml.org/lkml/2014/4/8/239

Tomasz, It will be good if you can review remaining patches under this
series, specially patch [2].
So that, I can update this series after addressing all comments.

2: https://lkml.org/lkml/2014/5/10/26


> Then, registration of the normal syscon would happen through standard
platform
> driver mechanisms and no special early handling would be necessary.
> 
> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

