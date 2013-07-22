Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3GVMOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:14:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30110 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3GVMOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:14:44 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-5b-51ed22316c0c
Message-id: <51ED2230.8080100@samsung.com>
Date: Mon, 22 Jul 2013 14:14:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] clk: exynos4: Add CLK_GET_RATE_NOCACHE flag for the
 Exynos4x12 ISP clocks
References: <1372099374-21008-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372099374-21008-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xa7qGSm8DDT7PsbA42/SG3WLT42us
	Fpd3zWGzmHF+H5PF0wkX2RxYPe5c28PmsXlJvUffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	vJ3cyVwwj6Vi+bM3rA2Mu5i7GDk5JARMJJ5+/MICYYtJXLi3nq2LkYtDSGApo8Sa+wuZIZxP
	jBKPpk8C6+AV0JKYdacPrINFQFVi+aGzjCA2m4ChRO/RPjBbVCBAYvGSc+wQ9YISPybfA6sX
	EZCUePB5OgvIUGaBNkaJzavuMYEkhAUSJOZd/wxWJCTgJvG76z0biM0p4C4xZcZyMJtZQEdi
	f+s0KFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKE
	BPLXHYxLj1kdYhTgYFTi4W0IeBMoxJpYVlyZe4hRgoNZSYTXcxVQiDclsbIqtSg/vqg0J7X4
	ECMTB6dUAyNbAOfTmxcn71bR3LJVQ6qht/nCN+6+SyIiq4ufbLVSq9vd/GWdhT7fG0euV+z3
	d5ftrO5fUjjXq/nli6V20x0zDE/+eHN68pmQ/98/KAe7hBfVSq/qvh4duzUz9LjtJc+pJ5aW
	hC/XMcx727t3ve6KjmnTTpSqFz5WNJU4bKfkz71kGbPEjkQlluKMREMt5qLiRAAUJprwQgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 08:42 PM, Sylwester Nawrocki wrote:
> The ISP clock registers belong to the ISP power domain and may change
> their values if this power domain is switched off/on. Add
> CLK_GET_RATE_NOCACHE flags to ensure we do not rely on invalid cached
> data when setting or getting frequency of those clocks.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Mike,

would you consider queueing that patch for current -rc cycle ?

Thanks,
Sylwester

