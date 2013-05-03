Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873Ab3ECOID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:08:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10024 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762307Ab3ECOH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:07:59 -0400
X-AuditID: cbfee690-b7f136d000000fea-39-5183c4bdbb8b
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocky" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [RFC v2 0/3] LAB: Support for Legacy Application Booster governor
Date: Fri, 03 May 2013 23:07:49 +0900
Message-id: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkSHfvkeZAgw1tRhZPm36wW8z7LGvx
	5uFmRovLu+awWXzuPcJocbtxBZtF/8JeJouOI9+YLTZ+9XDg9LhzbQ+bR9+WVYwejxa3MHp8
	3iQXwBLFZZOSmpNZllqkb5fAldF55i5bwTrhisndOQ2M2/m7GDk5JARMJO6/eMUGYYtJXLi3
	Hsjm4hASWMoo0bbxPCNM0ebOFYwQiUWMEn9e9TJDOC1MEvs+PWICqWIT0JH4v+8mO4gtIqAg
	sbn3GStIEbPANiaJGZ8mgxUJC3hJrL+9nhXEZhFQlZiyYhJYnFfAQ+L7wk6gOAfQOgWJOZNs
	QHolBNrZJbZuug5VLyDxbfIhFogaWYlNB5ghrpOUOLjiBssERsEFjAyrGEVTC5ILipPSi0z0
	ihNzi0vz0vWS83M3MQKD9/S/ZxN2MN47YH2IMRlo3ERmKdHkfGDw55XEGxqbGVmYmpgaG5lb
	mpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0czzStmDiP2e5+5M+aA85dX/
	z30rH+148jSq74Pq6svRfYyb11TqLLS1U34yQ5Ov4ePhtkULrju+mPG7a0vCF/7q49yuJxNu
	n1HitvnU86W//JbJ+e+uv2W7wxMtVJbr/dzxbX7Z08Ydmi3/+H5vkCzaWemlrTnziWrn/qNv
	a/k5LsbFWrIW1SuxFGckGmoxFxUnAgBmFZ2pdAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAd29R5oDDTrmqFo8bfrBbjHvs6zF
	m4ebGS0u75rDZvG59wijxe3GFWwW/Qt7mSw6jnxjttj41cOB0+POtT1sHn1bVjF6PFrcwujx
	eZNcAEtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtApSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMzjN32QrWCVdM7s5p
	YNzO38XIySEhYCKxuXMFI4QtJnHh3nq2LkYuDiGBRYwSf171MkM4LUwS+z49YgKpYhPQkfi/
	7yY7iC0ioCCxufcZK0gRs8A2JokZnyaDFQkLeEmsv72eFcRmEVCVmLJiElicV8BD4vvCTqA4
	B9A6BYk5k2wmMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcG8+kdzCuarA4xCjA
	wajEw6vQ0hQoxJpYVlyZe4hRgoNZSYQ3o7E5UIg3JbGyKrUoP76oNCe1+BBjMtDyicxSosn5
	wLjNK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZG5tAfN1i9
	tuWYTPUt38jYJul4bMXsGMF4seNNBZUs5yyjGiYIrV9y+vA0lZvLVsgemugWkxE2Ia560R/D
	7d7s50ICt84v/LpfmsfYNGj/t7SdR98fP/rxZqJrSWuJDX/JqyShhl43Llt3raYgKY7qd8vS
	Pfy3a/DfU3IMTst4sCAnsYtlvZgSS3FGoqEWc1FxIgDI46QQ0QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukasz Majewski <l.majewski@samsung.com>

The purpose of this series is to discuss assumptions and idea of implementing
LAB governor support. It shall be treated as a proof-of-concept code for new
(fresh) view on power consumption reduction.

It is divided to three big parts:
1. Low-level code for supporting frequency overclocking at Exynos4 SoCs.
Moreover support for cpufreq_overclock_* interface functions has been added.
This feature is implemented in a way to reduce number of changes at cpufreq
core driver to minimum. 

It alters entries at SoC specific frequency table to allow above the standard 
limits frequency. Exynos TMU (Thermal Management Unit) is a "safe valve" to 
disable overclocking when overheating is detected.

Despite, that this solution is Exynos4 specific it can be easily ported to other 
SoCs.

2. New LAB governor.
It calculates number of idle CPUs (based on scheduler data). On this basis it 
chose proper first level polynomial function for approximation.
Moreover it enables overclocking when single, heavy loaded CPU is running.

Those new heuristics allow for more platform tight frequency level decision.
To work efficienty this governor relies on scheduler to pack as much tasks as 
possible to running cores and put other to IDLE.
Following patches are helpful (one of):
- Vincent Guittot's "packing small tasks" patch
- Alex Shi's power-aware scheduling patch

3. Set of changes needed at core cpufreq code.
The only relevant change is to store idle_time value for each CPU.

Tested at 3.8 linux kernel, Exynos4412 Device

For more details please see respect log messages.


Lukasz Majewski (3):
  cpufreq:overclocking: Overclocking support at Exynos4 SoC
  cpufreq:LAB: Introduce new cpufreq LAB(Legacy Application Boost)
    governor
  cpufreq:LAB: Modify cpufreq_governor to support LAB Governor


 drivers/cpufreq/Kconfig              |   33 +++
 drivers/cpufreq/Makefile             |    1 +
 drivers/cpufreq/cpufreq_governor.c   |    7 +
 drivers/cpufreq/cpufreq_governor.h   |   15 ++
 drivers/cpufreq/cpufreq_lab.c        |  450 ++++++++++++++++++++++++++++++++++
 drivers/cpufreq/exynos-cpufreq.c     |  108 ++++++++
 drivers/cpufreq/exynos-cpufreq.h     |    7 +
 drivers/cpufreq/exynos4x12-cpufreq.c |   15 ++
 include/linux/cpufreq.h              |   35 +++
 9 files changed, 671 insertions(+)
 create mode 100644 drivers/cpufreq/cpufreq_lab.c

-- 
1.7.9.5

