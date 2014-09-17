Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbaIQQtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:49:40 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:46316 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbaIQQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:49:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=VsSg5QLbdhgb4vV1+boeWaksCGj4MfGnCQnyhQR6Dr5A@mail.gmail.com>
References: <1409216559-22402-1-git-send-email-cw00.choi@samsung.com>
	<1409216559-22402-5-git-send-email-cw00.choi@samsung.com>
	<CABxcv=ku9fjFfzyXZEnCGpTrWQ0pN+5mLWay90jXBhkFeWb7sg@mail.gmail.com>
	<CAD8Lp47M8jHLrQAdYUn6NZn2Ety_02E6HPzPDUX3uGLVqf1riw@mail.gmail.com>
	<CABxcv==CBbaY_GVgmWe5QzJdhMipyx5TpZ4_3oKLzkyiGPOBrw@mail.gmail.com>
	<CAD=FV=VsSg5QLbdhgb4vV1+boeWaksCGj4MfGnCQnyhQR6Dr5A@mail.gmail.com>
Date: Wed, 17 Sep 2014 10:49:35 -0600
Message-ID: <CAD8Lp45LyE6AuGgC7xKyFiniF2K4v_G1X-=QARrJ1DqLYRy3Lg@mail.gmail.com>
Subject: Re: [PATCHv3 4/5] rtc: s3c: Add support for RTC of Exynos3250 SoC
From: Daniel Drake <drake@endlessm.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, rtc-linux@googlegroups.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 4:15 PM, Doug Anderson <dianders@chromium.org> wrote:
> NOTE: I don't think that the builtin RTC is terribly important for any
> exynos-based Chromebooks that I'm aware of.  We rely on the RTC that's
> part of the Maxim PMIC itself and pretty much ignore the one built-in
> to the exynos.  I think there are some cases it was used (as a
> fallback wakeup source in certain test scripts), but nothing very
> important.

That's not true for all hardware though, at least the board I'm
working on now has the SoC RTC as battery-backed and the PMIC one with
no battery. So in this case at least, the interesting RTC is the SoC
one.

Daniel
