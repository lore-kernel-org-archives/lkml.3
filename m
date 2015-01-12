Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbbALJ2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:28:41 -0500
Received: from mail.kernel.org ([198.145.29.136]:36430 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbbALJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:28:40 -0500
Message-ID: <54B393B9.6060806@kernel.org>
Date: Mon, 12 Jan 2015 18:28:25 +0900
From: Kukjin Kim <kgene@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: Kukjin Kim <kgene@kernel.org>, ben-linux@fluff.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH] ARM: EXYNOS: Add exynos3250 suspend-to-ram support
References: <1420681838-4292-1-git-send-email-cw00.choi@samsung.com> <54B38989.4030700@kernel.org> <54B38B24.20804@samsung.com>
In-Reply-To: <54B38B24.20804@samsung.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/15 17:51, Chanwoo Choi wrote:
> Dear Kukjin,
> 
> On 01/12/2015 05:44 PM, Kukjin Kim wrote:
>> On 01/08/15 10:50, Chanwoo Choi wrote:
>>> This patch adds the support for suspend-to-ram feature of Exynos3250 SoC.
>>> Exynos3250 don't contain the L2 cache.
>>>
>>> Cc: Kukjin Kim <kgene@kernel.org>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>> Depend on:
>>> - v3.19-rc3
>>>
>> Chanwoo,
>>
>> Can you please let me know why this is depending on v3.19-rc3?
>> If I apply this on top of my tree not including some stuff between
>> v3.19-rc1 and v3.19-rc3, is there a problem?
> 
> No problem.
> I'm sorry. It is my mistake about using meaning of dependency.
> This patch can be applied on v3.19-rc1. I just tested it on v3.19-rc3.
> 
OK, applied.

Thanks,
Kukjin
