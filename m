Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaDOIMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:12:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:52010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaDOIMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:12:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        kgene.kim@samsung.com, t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, olof@lixom.net, marc.zyngier@arm.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/8] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
Date: Tue, 15 Apr 2014 10:11:57 +0200
Message-ID: <4788081.xvaJfdGTMu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397527192-21988-4-git-send-email-cw00.choi@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com> <1397527192-21988-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uYO46ASPj4w1MLZyWhx1TiszDMf0fZg7UTg9Xa+0jeb
 KJPZECtwlzTXyxxk9awPsds5obE7EUAFJZGCoUY2jFyf2H4v5h
 gbsiYgKMgnA1HsUenHNQ8LVyJ945t0QJX53LxHWMTFTdHiNSP6
 vU6ptcWVAc0Pq8zjLleSJtulK8LPPJlaiNpEOxjXoxP89+k6jF
 +9Ksgvx/0d5nWBU7RnyH4IeXEo7G1PA9tKOAoETl4ChuKF1sqx
 JRvoSfysCnVbgrzCsh33qZ+snWqCgiW1z0uePhTPLKQ8sOX7Ce
 6B7Z7PvoGzjXbeQt84LRqbN3q0ycZl5EXKDeif66OsqbVJK1ZS
 hFcmA5bIE+TZe/I+j5gw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2014 10:59:47 Chanwoo Choi wrote:
> This patch add memory mapping for PMU (Power Management Unit) which is used
> for power control of Exynos3250.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Arnd Bergmann suggested that need proper driver instead of static memory mapping.
> As Chanho Park reply[2], Sachin Kamat already posted the DT support patch[1]
> for memory mapping for SYSRAM.
> [1] http://www.spinics.net/lists/linux-samsung-soc/msg27647.html
> [2] https://lkml.org/lkml/2014/4/10/161
> 
> So, I'm going to re-implement following patch related to static memory mapping
> after merged Sachin Kamat patch[1].
>   ARM: EXYNOS: Add IO mapping for PMU of Exynos3250

I don't think we have a patch for the PMU yet, Sachin was looking at the SYSRAM
only.

	Arnd
