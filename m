Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaLWO5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:57:50 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:50362 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLWO5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:57:48 -0500
MIME-Version: 1.0
Reply-To: cw00.choi@samsung.com
In-Reply-To: <54997113.2080804@samsung.com>
References: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
	<54997113.2080804@samsung.com>
Date: Tue, 23 Dec 2014 23:57:47 +0900
Message-ID: <CAGTfZH2VS-sVoeGcOWyB=MYPTd43e6wPF1sj6DjsDj-6vYCHxA@mail.gmail.com>
Subject: Re: [PATCH 0/3] clk: samsung: Use samsung_cmu_register_one() to
 simplify code
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Tue, Dec 23, 2014 at 10:41 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Chanwoo,
>
> On 23/12/14 08:40, Chanwoo Choi wrote:
>> This patch-set uses the samsung_cmu_register_one() function to simplify the
>> clock driver for Exynos3250/Exynos4415 SoC and change return value of
>> samsung_cmu_register_one() because some clock driver may need the instance
>> of samsung_clk_provider structure.
>>
>> Chanwoo Choi (3):
>>   clk: samsung: Changes the return value of samsung_cmu_register_one()
>>   clk: samsung: exynos3250: Use samsung_cmu_register_one() to simplify code
>>   clk: samsung: exynos4415: Use samsung_cmu_register_one() to simplify code
>>
>>  drivers/clk/samsung/clk-exynos3250.c | 217 ++++++++---------------------------
>>  drivers/clk/samsung/clk-exynos4415.c | 216 ++++++++--------------------------
>>  drivers/clk/samsung/clk.c            |  13 ++-
>>  drivers/clk/samsung/clk.h            |   3 +-
>>  4 files changed, 107 insertions(+), 342 deletions(-)
>
> Thanks for the cleanup, I've queued that for 3.20. And fixed a minor
> checkpatch warning when applying:
>
> ERROR: "foo* __init bar" should be "foo * __init bar"
> #29: FILE: drivers/clk/samsung/clk.c:377:
> +struct samsung_clk_provider* __init samsung_cmu_register_one(
>
> total: 1 errors, 0 warnings, 42 lines checked
>
> 0001-clk-samsung-Changes-the-return-value-of-samsung_cmu_.patch has style
> problems, please review.

I'll fix it and re-send these patch-set.

Best Regards,
Chanwoo Choi
