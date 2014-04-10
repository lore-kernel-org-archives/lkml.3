Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823AbaDJJk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:40:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:65237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965825AbaDJJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:40:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com, linux-samsung-soc@vger.kernel.org,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 06/27] ARM: EXYNOS:: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7
Date: Thu, 10 Apr 2014 11:40:43 +0200
Message-ID: <4896629.u0Ek9zNPG2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397122124-15690-7-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com> <1397122124-15690-7-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rpC3rsWwsybEr4JOaT4TgbGFT0njdecsgJd/QFj5jWB
 EUxQS7gd0YhJ/5KvSCQUstmOgE+aAc+tjM0ObQm3sI4hmL5zbH
 ZbdDm1u4gV6Ybh6pv9JqGP8CGQGy3FrZ0xerZSQoczOpNm1YPu
 qVKm/VUmMDy5UePG5IIJxDG7mbGbiuRN3Yd0q79acyhcePIfdt
 ayrtPufFy+Y2AMGzMlcCNarATd3uXdXekLPDJtJlBK1b0zdL2Z
 D98E/4scQjpckYhdh9y5KjlnqVUVPd6IUWE/j8drpYbvPpXWS1
 6kdV8azfRmoaeQCegR7QLMJQnXDKSOVnxgIxd/slp3B9jabvgi
 aZSUFjSnK4CX4yNJIv0Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2014 18:28:23 Chanwoo Choi wrote:
> +        * while Exynos5 is A15/Exynos7 is A7; check the CPU part
> 

Exynos7 -> Exynos3 ?

	Arnd
