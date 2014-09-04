Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaIDKRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:17:03 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:55985 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbaIDKRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:17:01 -0400
Message-ID: <1409825817.5546.99.camel@x220>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Thu, 04 Sep 2014 12:16:57 +0200
In-Reply-To: <53C676DB.6070002@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-19-git-send-email-t.figa@samsung.com>
	 <1405505756.4408.24.camel@x220> <53C676DB.6070002@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 10:16:58.0162 (UTC) FILETIME=[5C1C8120:01CFC829]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 14:58 +0200, Tomasz Figa wrote:
> On 16.07.2014 12:15, Paul Bolle wrote:
> > After this patch that symbol is still referenced in:
> > drivers/media/platform/Kconfig:159:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
> > drivers/media/platform/Kconfig:169:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
> > drivers/media/platform/Kconfig:177:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
> > drivers/media/platform/exynos4-is/Kconfig:5:    depends on (PLAT_S5P || ARCH_EXYNOS)
> > drivers/media/platform/s5p-tv/Kconfig:11:       depends on (PLAT_S5P || ARCH_EXYNOS) && PM_RUNTIME
> > drivers/usb/host/Kconfig:223:       depends on PLAT_S5P || ARCH_EXYNOS
> > drivers/usb/host/Kconfig:530:   depends on PLAT_S5P || ARCH_EXYNOS
> > 
> > Again, I assume patches to remove these references are pending. But is
> > that correct?
> 
> I had two patches fixing those, but apparently this was lost in action.
> The correct solution is s/PLAT_S5P/ARCH_S5PV210/. I will include this in
> a follow-up series if nobody objects.

No one objected, as far as I know.

Exactly the same references are still to be found in v3.17-rc3 and
next-20140903. Perhaps someone actually familiar with this matter (ie,
not me) could submit one or more patches that implement Tomasz'
proposal.


Paul Bolle

