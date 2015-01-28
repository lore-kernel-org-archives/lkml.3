Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbbA1WNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:13:36 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42365 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbbA1UQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:16:50 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-2b-54c9249eb040
Message-id: <54C92522.7050207@samsung.com>
Date: Wed, 28 Jan 2015 19:06:26 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [GIT PULL] clk/samsung updates for v3.20
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xy7rzVE6GGFx9xWJxedccNosZ5/cx
	WTydcJHN4seZbhaLVbv+MDqwelzu62Xy2DnrLrvHnWt72Dw+b5ILYInisklJzcksSy3St0vg
	ymg91shecJyn4udSuQbGxVxdjJwcEgImEteam5ggbDGJC/fWs3UxcnEICSxllDj6ZhIrhPOJ
	UeLInM9AVRwcvAJaEjPPmII0sAioShx/c4IVxGYTMJToPdrHCGKLCkRInLy7hx3E5hUQlPgx
	+R4LiC0C1LrtQCvYAmaBfkaJq2e3gjULAzV/2zWVFWQ+s4C6xJQpuSBhZgF5ic1r3jJPYOSb
	hWTULISqWUiqFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQICcmvOxiXHrM6xCjAwajE
	w8vgcyJEiDWxrLgy9xCjBAezkghvP8vJECHelMTKqtSi/Pii0pzU4kOMTBycUg2MTQusv58u
	TjurarHgbw+/j+vZ9p6J1/6dP/mZ2f5DfueF1Q7q5QJRj6bzlMz70Gp72sBh/RQOYat3Ib02
	plrTPkQHfOu/buzeafZR4Y/ItoteC6Wnn5Rlq7vLZeEiZnZd//4ujqkP3vH9/lS1V7dgyfEt
	3AELpb8qsmzSvidQLrtkSsWfC+WFSizFGYmGWsxFxYkAO1wxGCcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mike,

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git tags/v3.20-exynos-clk

for you to fetch changes up to e64fb42da4c6c713cfc7cad607e97e0773fa41ff:

  clk: samsung: exynos4: Add divider clock id for memory bus frequency
(2015-01-28 15:51:17 +0100)

----------------------------------------------------------------
Exynos 3250, 4415 drivers cleanup by using common code
and addition of clock definitions for DVFS on Exynos4.

----------------------------------------------------------------

It's just couple mostly cleanup patches this time, we have a clk driver
for exynos5433 pending yet but I'll likely send it after the coming merge
window.

Chanwoo Choi (4):
      clk: samsung: Change the return value of samsung_cmu_register_one()
      clk: samsung: exynos3250: Use samsung_cmu_register_one() to simplify code
      clk: samsung: exynos4415: Use samsung_cmu_register_one() to simplify code
      clk: samsung: exynos4: Add divider clock id for memory bus frequency

 drivers/clk/samsung/clk-exynos3250.c |  217 ++++++++--------------------------
 drivers/clk/samsung/clk-exynos4.c    |   10 +-
 drivers/clk/samsung/clk-exynos4415.c |  216 ++++++++-------------------------
 drivers/clk/samsung/clk.c            |   13 +-
 drivers/clk/samsung/clk.h            |    3 +-
 include/dt-bindings/clock/exynos4.h  |    7 +-
 6 files changed, 118 insertions(+), 348 deletions(-)

--
Thanks
Sylwester
