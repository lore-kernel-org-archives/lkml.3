Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbaBUQmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:42:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaBUQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:42:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kishon@ti.com,
        linux-samsung-soc@vger.kernel.org, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] phy: Select PHY_EXYNOS_DP_VIDEO by default for ARCH_EXYNOS
Date: Fri, 21 Feb 2014 17:41:35 +0100
Message-ID: <1888663.ccFYmJ9QJl@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <53077DE0.7080108@samsung.com>
References: <1392997802-29050-1-git-send-email-s.nawrocki@samsung.com> <1753680.KKj0Q1erxA@wuerfel> <53077DE0.7080108@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UhnH5QFPxzx79OfxZvsNE3Tc+JYmz7DJ42hf5zUeVTS
 uM+dZcAOQ5gSd0nnoJEiXW0IQRO2vl/vdr7RdfEwVNxFlD0YPV
 FUjqV9vwVi/VIcXzbaLzins63+e56ngmvSXzIq/pZgeNapEFtV
 7fPywIZ28CXSSJGutdULlnIxRM1ScBVuYGmdFWp2D62saFOJv2
 X8sRzr/8RxOg7YCk8/VxCSW3aoRu1NM7dAq2nF5v30GX6K6ZCB
 OEZ0nIR54N0RZUnGK2qFWekUm/a08mwHijrs+sk5blPwVbfBxG
 6AFm4LiYSR1RZW8TozaRUqML1uIxEllj3T6msWDyhqd0bgGo+A
 MzeM2PLecb8QQUCzW6ro=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 17:25:04 Sylwester Nawrocki wrote:
> 
> Hmm, good point, I will modify it that way.
> 
> For patch 1/2 I guess it should be:
> 
> "default ARCH_S5PV210 || ARCH_EXYNOS"
> 
> or rather
> 
> "default y if ARCH_S5PV210 || ARCH_EXYNOS" ?

Right. I'd probably use the first syntax, but it doesn't really matter.

	Arnd
