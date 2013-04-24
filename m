Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3DXQdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:33:10 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60565 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3DXQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:33:08 -0400
MIME-Version: 1.0
In-Reply-To: <51780348.6090202@linaro.org>
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
 <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
 <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de> <51780348.6090202@linaro.org>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Apr 2013 18:32:47 +0200
Message-ID: <CAPXgP10OJGHwZZHCtUMZfnSzj2cKJmg6NGg2pPKiuHWPKuuo-Q@mail.gmail.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK changes?
To: John Stultz <john.stultz@linaro.org>
Cc: Alexander Holler <holler@ahsoftware.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 6:07 PM, John Stultz <john.stultz@linaro.org> wrote:

> So summarizing the above, because as much as I'm aware, its always been
> redundant and unnecessary on x86.  Thus being able at build time to mark it
> as unnecessary was attractive, since it reduced the code paths running at
> suspend/resume.
>
> That said, Kay's concerns about userland implications (basically the
> userland side effects of SYSTOHC being enabled) give me pause, so I may
> revert the HAS_PERSISTENT_CLOCK on x86 change.

Thanks a lot for all the missing details!

No, I think that all makes too much sense to revert it. Let's just
find a way to solve it properly. I don't think it is of any pressing
importance to keep the old behaviour, if we can still provide the
functionality today.

I'll continue replying in the later mail ...

Kay
