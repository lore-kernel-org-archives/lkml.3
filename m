Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaBUSAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:00:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:52954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaBUSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:00:07 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2014 13:00:06 EST
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Subject: Re: [PATCH v2 2/2] phy: Select PHY_EXYNOS_DP_VIDEO by default for ARCH_EXYNOS
Date: Fri, 21 Feb 2014 18:54:07 +0100
Message-ID: <1413607.hGO0bhiXpo@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <530783E4.6090206@samsung.com>
References: <1392997802-29050-1-git-send-email-s.nawrocki@samsung.com> <1888663.ccFYmJ9QJl@wuerfel> <530783E4.6090206@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qG/Kqt1/s5el3wXz2PUMJXh3N4ybNWfx2W3QUnVmqe5
 i0ie6j/0dysZMQX8GJ0XxyA5az1SKJFztwZ6hwXAsV5A8mmIez
 TtjtWoe2RmsoDkyDa9R0EszrTgQyVdxbVfcG6hW8i2pSiEZ5i5
 GD9AxPBDLkeRNptdqBEZ6ma1wag+TvMzJEpaWsilHesQyjcFo9
 mKvusgV5s32D+daaOvalKw0aDLTqwH19vSu5NtEQrCabTcar5D
 lC0I7ChYqQJplxc8tsALH4fgwm177QPtOdfiqQ9CQKN0x0GbHd
 oU3P9Sg58IGUVb6AC3zdOjU+iOEbwPkazSL2KQiTuS8/sBhQvf
 DFx0bh4b2Lp0NnNtI71g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 17:50:44 Sylwester Nawrocki wrote:
> On 21/02/14 17:41, Arnd Bergmann wrote:
> > On Friday 21 February 2014 17:25:04 Sylwester Nawrocki wrote:
> >> > 
> >> > Hmm, good point, I will modify it that way.
> >> > 
> >> > For patch 1/2 I guess it should be:
> >> > 
> >> > "default ARCH_S5PV210 || ARCH_EXYNOS"
> >> > 
> >> > or rather
> >> > 
> >> > "default y if ARCH_S5PV210 || ARCH_EXYNOS" ?
> >
> > Right. I'd probably use the first syntax, but it doesn't really matter.
> 
> Oops, I've already sent patch using the second one, as it seemed
> more common.

As I said, it doesn't matter.

	Arnd
