Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3GIVSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:18:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51899 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3GIVSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:18:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF DECLARE
Date: Tue, 9 Jul 2013 23:16:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Neil Zhang <zhangwm@marvell.com>, grant.likely@linaro.org,
        haojian.zhuang@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com> <1373352166-10064-3-git-send-email-zhangwm@marvell.com> <20130709181434.76f6216d@skate>
In-Reply-To: <20130709181434.76f6216d@skate>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307092316.20905.arnd@arndb.de>
X-Provags-ID: V02:K0:Z/nDu/+jEFOS6qYT9S4Dvox3gkjXOVPazmYVN2CYqVz
 NFIFhiCshnzQllRDOAw1BzOWXI/c4aqrI2dAV9MVITGy1FHpeS
 hDgIRYcKPmgteEj20CRXrHUwY8KuZYFX2wQ1FP752p66iPiBOD
 2oXpjIUs5LFm4dOt6MwPnT0LlcnqMFFaQdMrn1+0VeanTRpe2s
 8lwdO7u1Cm7w8b9XZgA0l58Pj1HgKh27PCEzqY2d+MBDReSYHP
 I28LhWnvVLs3VeCJR4N9QQRZ3LfaNQAGa7epoIVONsY2r1UHrk
 3+EXhHOXIIOlyJrLdS1gk/kOvtN1qDaRer+QlEbL7/Qga3HNrY
 Ektd8+FdSxrq+lgQ/7No=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 July 2013, Thomas Petazzoni wrote:
> Dear Neil Zhang,
> 
> On Tue, 9 Jul 2013 14:42:45 +0800, Neil Zhang wrote:
> > support CLOCKSOURCE OF DECLARE for mmp timer.
> > 
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  arch/arm/mach-mmp/mmp-dt.c  |    5 ++---
> >  arch/arm/mach-mmp/mmp2-dt.c |    3 +--
> >  arch/arm/mach-mmp/time.c    |   15 ++-------------
> >  3 files changed, 5 insertions(+), 18 deletions(-)
> 
> Maybe it would be good to take this opportunity to move
> arch/arm/mach-mmp/time.c into drivers/clocksource/.

+1

Or we might want to have a more coordinated move of all clocksource
drivers in arch/arm to drivers/clocksource now, as we have done for some
other subsystems.

	Arnd
