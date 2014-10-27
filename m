Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaJ0Kjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:39:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29401 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaJ0Kjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:39:52 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-80-544e20f5795f
Message-id: <544E20E3.5030609@samsung.com>
Date: Mon, 27 Oct 2014 11:39:31 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: tomasz.figa@gmail.com, kgene.kim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/2] clk: samsung: Add clock controller driver for
 Exynos4415 SoC
References: <1414372318-594-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1414372318-594-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7pfFfxCDC428Vpc//Kc1eLPhFY2
	i0n3J7BY9C64ymZxtukNu8XlXXPYLGac38dkMWPySzaLVbv+MDpweuycdZfdo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDLuHZ7IXvCCqWLLltgGxoVMXYycHBICJhI9G/czQ9hiEhfurWfr
	YuTiEBJYyiixt/8MI4TziVHiypzfbCBVvAJaEvOvrWMBsVkEVCW+PNjGCGKzCRhK9B7tA7NF
	BSIkTt7dww5RLyjxY/I9sHoRAQ2JmX+vgA1lFrjOKPHn1zyw1cICkRIH5rWDnSQk4CzxcO4R
	sGZOAReJr3dvAdkcQA16EvcvaoGEmQXkJTavecs8gVFgFpIVsxCqZiGpWsDIvIpRNLU0uaA4
	KT3XUK84Mbe4NC9dLzk/dxMjJMS/7GBcfMzqEKMAB6MSD++Oab4hQqyJZcWVuYcYJTiYlUR4
	HX8ChXhTEiurUovy44tKc1KLDzEycXBKNTB2Tl++8UbLCZ67D43+vDRwSkw87LUycTv73ota
	aYULBfnZXs8++VbqckVyf//LpcIVVnqTlr6RW2m1ddq8v46et87n5nHwuE+ZH5q5IY37/m53
	30Dr6qk8uzR+9u/MWaKXu2nSs7OfHn38tZblkFfhwQ0mLYdfa7zQbmr9ZqXILqy8JD9Jql1S
	iaU4I9FQi7moOBEAfpovy08CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/14 02:11, Chanwoo Choi wrote:
> Chanwoo Choi (2):
>   clk: samsung: exynos4415: Add clocks using common clock framework
>   clk: samsung: Document binding for Exynos4415 clock controller

Added both to my tree, thanks. In future please put DT binding
documentation first in the series, before the actual driver patch.

--
Thanks,
Sylwester
